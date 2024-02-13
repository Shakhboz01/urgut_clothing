class SalesController < ApplicationController
  before_action :set_sale, only: %i[ show edit update destroy toggle_status ]

  include Pundit::Authorization
  # GET /sales or /sales.json
  def index
    @q = Sale.ransack(params[:q])
    @sales =
      @q.result.filter_by_total_paid_less_than_price(params.dig(:q_other, :total_paid_less_than_price))
        .order(id: :desc)

    @sales_data = @sales
    @sales = @sales.page(params[:page]).per(70)
  end

  # GET /sales/1 or /sales/1.json
  def show
    @product_sells = @sale.product_sells
    @product_sell = ProductSell.new(sale_id: @sale.id)
    @products = Product.active.order(:name)
    @rate = CurrencyRate.last.rate
  end

  # GET /sales/new
  def new
    @sale = Sale.new
  end

  # GET /sales/1/edit
  def edit
  end

  # POST /sales or /sales.json
  def create
    @sale = Sale.new(sale_params)
    @sale.user_id = current_user.id
    respond_to do |format|
      if @sale.save
        format.html { redirect_to sales_url(@sale), notice: "Sale was successfully created." }
        format.json { render :show, status: :created, location: @sale }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sales/1 or /sales/1.json
  def update
    respond_to do |format|
      if @sale.update(sale_params.merge(
          status: sale_params[:status].to_i,
          total_price: @sale.calculate_total_price(false)
        ))
        format.html { redirect_to sales_url, notice: "Sale was successfully updated." }
        format.json { render :show, status: :ok, location: @sale }
      else
        format.html { redirect_to request.referrer, notice: @sale.errors.messages.values }
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sales/1 or /sales/1.json
  def destroy
    @sale.destroy

    respond_to do |format|
      format.html { redirect_to sales_url, notice: "Sale was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def default_create
    buyer = Buyer.first
    last_one = Sale.last
    if !last_one.nil? && last_one.total_price == 0 && last_one.total_paid == 0 && !last_one.closed?
      redirect_to sale_url(last_one), notice: "Теперь добавьте продажу товаров"
    else
      sfs = Sale.new(buyer: buyer, user: current_user)
      if sfs.save
        redirect_to sale_url(sfs), notice: 'Теперь добавьте продажу товаров'
      else
        redirect_to request.referrer, notice: "Something went wrong"
      end
    end
  end

  def toggle_status
    authorize Sale, :manage?

    @sale.update(status: @sale.closed? ? 0 : 1)
    redirect_to request.referrer, notice: 'Successfully updated'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_sale
    @sale = Sale.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def sale_params
    params.require(:sale).permit(
      :total_paid, :payment_type, :buyer_id, :total_price, :comment,
      :user_id, :status, :discount_price, :price_in_usd
    )
  end
end
