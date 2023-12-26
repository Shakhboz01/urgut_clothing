class CurrencyConversionsController < ApplicationController
  before_action :set_currency_conversion, only: %i[ show edit update destroy ]

  # GET /currency_conversions or /currency_conversions.json
  def index
    @rate = CurrencyRate.last.rate
    @q = CurrencyConversion.ransack(params[:q])
    @currency_conversions = @q.result.order(id: :desc)
    @all_currency_conversions = @currency_conversions
    @currency_conversions = @currency_conversions.page(params[:page]).per(40)
  end

  # GET /currency_conversions/1 or /currency_conversions/1.json
  def show
  end

  # GET /currency_conversions/new
  def new
    rate = CurrencyRate.last.rate
    @currency_conversion = CurrencyConversion.new(rate: rate)
  end

  # GET /currency_conversions/1/edit
  def edit
  end

  # POST /currency_conversions or /currency_conversions.json
  def create
    @currency_conversion = CurrencyConversion.new(currency_conversion_params)
    @currency_conversion.user_id = current_user.id
    respond_to do |format|
      if @currency_conversion.save
        format.html { redirect_to currency_conversions_url, notice: "Currency conversion was successfully created." }
        format.json { render :show, status: :created, location: @currency_conversion }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @currency_conversion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /currency_conversions/1 or /currency_conversions/1.json
  def update
    respond_to do |format|
      if @currency_conversion.update(currency_conversion_params)
        format.html { redirect_to currency_conversions_url, notice: "Currency conversion was successfully updated." }
        format.json { render :show, status: :ok, location: @currency_conversion }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @currency_conversion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /currency_conversions/1 or /currency_conversions/1.json
  def destroy
    @currency_conversion.destroy

    respond_to do |format|
      format.html { redirect_to currency_conversions_url, notice: "Currency conversion was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_currency_conversion
      @currency_conversion = CurrencyConversion.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def currency_conversion_params
      params.require(:currency_conversion).permit(:rate, :to_uzs, :user_id, :price_in_uzs, :price_in_usd)
    end
end
