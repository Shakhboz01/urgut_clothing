class ProductSellsController < ApplicationController
  before_action :set_product_sell, only: %i[ show edit update destroy ]

  # GET /product_sells or /product_sells.json
  def index
    @q = ProductSell.ransack(params[:q])
    @product_sells = @q.result.includes(:product).order(id: :desc)
    @product_sells_data = @product_sells
    @rate = CurrencyRate.last.rate
    @product_sells = @product_sells.page(params[:page]).per(70)
  end

  # GET /product_sells/1 or /product_sells/1.json
  def show
    @q = ProductEntry.ransack(params[:q])
    @product_entries = @q.result.where(id: @product_sell.price_data.keys)
  end

  # GET /product_sells/new
  def new
    @product_sell = ProductSell.new(
      combination_of_local_product_id: params[:combination_of_local_product_id],
      sale_from_local_service_id: params[:sale_from_local_service_id],
      sale_from_service_id: params[:sale_from_service_id],
    )
  end

  # GET /product_sells/1/edit
  def edit
  end

  # POST /product_sells or /product_sells.json
  def create
    @product_sell = ProductSell.new(product_sell_params)

    respond_to do |format|
      if @product_sell.save
        format.html { redirect_to request.referrer, notice: "Product sell was successfully created." }
        format.json { render :show, status: :created, location: @product_sell }
      else
        format.html { redirect_to request.referrer, notice: @product_sell.errors.messages.values.join("\n") }
        format.json { render json: @product_sell.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /product_sells/1 or /product_sells/1.json
  def update
    respond_to do |format|
      if @product_sell.update(product_sell_params)
        format.html { redirect_to product_sell_url(@product_sell), notice: "Product sell was successfully updated." }
        format.json { render :show, status: :ok, location: @product_sell }
      else
        format.html { render :edit, product_sell: @product_sell, status: :unprocessable_entity }
        format.json { render json: @product_sell.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /product_sells/1 or /product_sells/1.json
  def destroy
    @product_sell.destroy
    respond_to do |format|
      format.html { redirect_to "#{request.referrer}?reload=true" }
      format.json { head :no_content }
    end
  end

  def ajax_sell_price_request
    return render json: ('Please fill forms') if product_sell_params[:pack_id].empty? || product_sell_params[:amount].to_i.zero?

    pack = Pack.find(params[:pack_id])
    rate = CurrencyRate.last.rate
    average_sell_price_in_usd = pack.price_in_usd ? pack.sell_price : (pack.sell_price / rate)
    average_sell_price_in_uzs = pack.price_in_usd ? (pack.sell_price * rate) : pack.sell_price
    minimum_buy_price_in_uzs =
      if pack.product_entries.exists?
        pack.product_entries.last.paid_in_usd ? (pack.product_entries.last.buy_price * rate) : pack.product_entries.last.buy_price
      else
        pack.price_in_usd ? (pack.buy_price * rate) : pack.buy_price
      end

    if product_sell_params[:sell_by_piece]
      quantity = pack.product_size_colors.sum(:amount)
      average_sell_price_in_usd /= quantity
      average_sell_price_in_uzs /= quantity
      minimum_buy_price_in_uzs /= quantity
    end

    render json: {
      average_sell_price_in_usd: average_sell_price_in_usd,
      average_sell_price_in_uzs: average_sell_price_in_uzs.to_i,
      minimum_buy_price_in_usd: minimum_buy_price_in_uzs.to_i
    }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_product_sell
    @product_sell = ProductSell.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def product_sell_params
    params.require(:product_sell).permit(
      :sale_from_local_service_id, :sale_id, :combination_of_local_product_id,
      :sell_price, :sell_price_in_uzs, :product_id, :total_profit, :amount, :payment_type, :pack_id, :barcode,
      :sell_by_piece
    )
  end
end
