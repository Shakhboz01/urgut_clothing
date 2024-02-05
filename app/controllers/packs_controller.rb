class PacksController < ApplicationController
  before_action :set_pack, only: %i[ show edit update destroy calculate_product_remaining]

  # GET /packs or /packs.json
  def index
    @packs = Pack.all
  end

  # GET /packs/1 or /packs/1.json
  def show
  end

  # GET /packs/new
  def new
    @random_code = Product.generate_code
    @random_barcode = Product.generate_barcode
    @pack = Pack.new
  end

  # GET /packs/1/edit
  def edit
    @random_code = @pack.code
    @random_barcode = @pack.barcode
  end

  # POST /packs or /packs.json
  def create
    @pack = Pack.new(pack_params)
    delivery = DeliveryFromCounterparty.find_by(pack_params['delivery_id'])
    respond_to do |format|
      if @pack.save
        if delivery
          format.html { redirect_to delivery_from_counterparty_url(delivery, pack_id: @pack.id), notice: "Pack was successfully created." }
        else
          format.html { redirect_to packs_url, notice: "Pack was successfully created." }
        end

        format.json { render :show, status: :created, location: @pack }
      else
        byebug
        format.html { redirect_to request.referrer, notice: @pack.errors.messages.values.join(' | ') }
        format.json { render json: @pack.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /packs/1 or /packs/1.json
  def update
    respond_to do |format|
      if @pack.update(pack_params)
        format.html { redirect_to pack_url(@pack), notice: "Pack was successfully updated." }
        format.json { render :show, status: :ok, location: @pack }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pack.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /packs/1 or /packs/1.json
  def destroy
    @pack.destroy

    respond_to do |format|
      format.html { redirect_to packs_url, notice: "Pack was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def filtered_packs
    code_value = params[:code_value].downcase.strip
    @filtered_packs = Pack.where("lower(code) LIKE ? OR lower(barcode) LIKE ?", "%#{code_value}%", "%#{code_value}%")
    respond_to do |format|
      format.js # assuming you have a corresponding js.erb file for the response
    end
  end

  def calculate_product_remaining
    calculate_product_remaining = @pack.calculate_product_remaining

    render json: { calculate_product_remaining: calculate_product_remaining }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pack
      @pack = Pack.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pack_params
      params.require(:pack).permit(
        :name, :code, :barcode, :delivery_id, :buy_price, :sell_price, :price_in_usd, :initial_remaining,
        product_size_colors_attributes: [:size, :color_id, :amount]
      )
    end
end
