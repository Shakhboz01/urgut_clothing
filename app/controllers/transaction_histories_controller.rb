class TransactionHistoriesController < ApplicationController
  before_action :set_transaction_history, only: %i[ show edit update destroy ]

  # GET /transaction_histories or /transaction_histories.json
  def index
    @special_filter_options = [['', 0], ['От продажи', 1], ['От покупки товаров', 2], ['От расходов', 3]]
    @q = TransactionHistory.where(first_record: false).ransack(params[:q])
    @transaction_histories = @q.result.order(id: :desc)
    unless (id = params.dig(:q_other, :special_filter).to_i).zero?
      case id
      when 1
        @transaction_histories = @transaction_histories.where.not(sale_id: nil)
      when 2
        @transaction_histories = @transaction_histories.where.not(delivery_from_counterparty_id: nil)
      when 3
        @transaction_histories = @transaction_histories.where.not(expenditure_id: nil)
      end
    end
    @transaction_histories_data = @transaction_histories
    @transaction_histories = @transaction_histories.page(params[:page]).per(40)
  end

  # GET /transaction_histories/1 or /transaction_histories/1.json
  def show
  end

  # GET /transaction_histories/new
  def new
    @transaction_history = TransactionHistory.new
  end

  # GET /transaction_histories/1/edit
  def edit
  end

  # POST /transaction_histories or /transaction_histories.json
  def create
    @transaction_history = TransactionHistory.new(transaction_history_params)
    @transaction_history.user_id = current_user.id
    respond_to do |format|
      if @transaction_history.save
        format.html { redirect_to request.referrer, notice: "Transaction history was successfully created." }
        format.json { render :show, status: :created, location: @transaction_history }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @transaction_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transaction_histories/1 or /transaction_histories/1.json
  def update
    respond_to do |format|
      if @transaction_history.update(transaction_history_params)
        format.html { redirect_to request.referrer, notice: "Transaction history was successfully updated." }
        format.json { render :show, status: :ok, location: @transaction_history }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @transaction_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transaction_histories/1 or /transaction_histories/1.json
  def destroy
    @transaction_history.destroy

    respond_to do |format|
      format.html { redirect_to request.referrer, notice: "Transaction history was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_transaction_history
    @transaction_history = TransactionHistory.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def transaction_history_params
    params.require(:transaction_history).permit(:sale_id, :sale_from_service_id, :sale_from_local_service_id, :delivery_from_counterparty_id, :expenditure_id, :price)
  end
end
