class CurrencyRatesController < ApplicationController
  before_action :set_currency_rate, only: %i[ show edit update destroy ]

  # GET /currency_rates or /currency_rates.json
  def index
    @q = CurrencyRate.ransack(params[:q])
    @currency_rates = @q.result.order(created_at: :desc).page(params[:page]).per(40)
  end

  # GET /currency_rates/1 or /currency_rates/1.json
  def show
  end

  # GET /currency_rates/new
  def new
    @currency_rate = CurrencyRate.new
  end

  # GET /currency_rates/1/edit
  def edit
  end

  # POST /currency_rates or /currency_rates.json
  def create
    @currency_rate = CurrencyRate.new(currency_rate_params)

    respond_to do |format|
      if @currency_rate.save
        format.html { redirect_to currency_rates_url, notice: "Currency rate was successfully created." }
        format.json { render :show, status: :created, location: @currency_rate }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @currency_rate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /currency_rates/1 or /currency_rates/1.json
  def update
    return;
    # respond_to do |format|
    #   if @currency_rate.update(currency_rate_params)
    #     format.html { redirect_to currency_rates_url, notice: "Currency rate was successfully updated." }
    #     format.json { render :show, status: :ok, location: @currency_rate }
    #   else
    #     format.html { render :edit, status: :unprocessable_entity }
    #     format.json { render json: @currency_rate.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # DELETE /currency_rates/1 or /currency_rates/1.json
  def destroy
    return;
    # @currency_rate.destroy

    # respond_to do |format|
    #   format.html { redirect_to currency_rates_url, notice: "Currency rate was successfully destroyed." }
    #   format.json { head :no_content }
    # end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_currency_rate
      @currency_rate = CurrencyRate.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def currency_rate_params
      params.require(:currency_rate).permit(:rate, :finished_at)
    end
end
