class SaleFromServicesController < ApplicationController
  before_action :set_sale_from_service, only: %i[ show edit update destroy ]

  # GET /sales or /sales.json
  def index
    @q = SaleFromService.ransack(params[:q])
    @sale_from_services =
      @q.result.filter_by_total_paid_less_than_price(params.dig(:q_other, :total_paid_less_than_price))
        .order(id: :desc)

    @all_sale_from_services = @sale_from_services
    @sale_from_services = @sale_from_services.page(params[:page]).per(40)
  end

  # GET /sales/1 or /sales/1.json
  def show
    @product_sells = @sale_from_service.product_sells
    @team_services = @sale_from_service.team_services
  end

  # GET /sales/new
  def new
    @sale_from_service = SaleFromService.new
  end

  # GET /sales/1/edit
  def edit
  end

  # POST /sales or /sales.json
  def create
    @sale_from_service = SaleFromService.new(sale_from_service_params)
    @sale_from_service.user_id = current_user.id
    respond_to do |format|
      if @sale_from_service.save
        format.html { redirect_to sale_from_service_url(@sale_from_service), notice: "Sale was successfully created." }
        format.json { render :show, status: :created, location: @sale_from_service }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sale_from_service.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sales/1 or /sales/1.json
  def update
    respond_to do |format|
      if @sale_from_service.update(sale_from_service_params.merge(status: sale_from_service_params[:status].to_i))
        format.html { redirect_to sale_from_services_url, notice: "Sale was successfully updated." }
        format.json { render :show, status: :ok, location: @sale_from_service }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sale_from_service.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sales/1 or /sales/1.json
  def destroy
    @sale_from_service.destroy

    respond_to do |format|
      format.html { redirect_to sale_from_services_url, notice: "Sale was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def default_create
    buyer = Buyer.first
    sfs = SaleFromService.new(buyer: buyer, user: current_user)
    if sfs.save
      redirect_to sale_from_service_url(sfs), notice: 'Теперь добавьте сервисы и рассход товаров'
    else
      redirect_to request.referrer, notice: "Something went wrong"
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_sale_from_service
    @sale_from_service = SaleFromService.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def sale_from_service_params
    params.require(:sale_from_service).permit(:total_paid, :payment_type, :buyer_id, :total_price, :comment, :user_id, :status)
  end
end
