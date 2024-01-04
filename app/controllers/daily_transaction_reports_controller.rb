class DailyTransactionReportsController < ApplicationController
  before_action :set_daily_transaction_report, only: %i[ show edit update destroy ]
  include Pundit::Authorization
  # GET /daily_transaction_reports or /daily_transaction_reports.json
  def index
    @q = DailyTransactionReport.ransack(params[:q])
    @daily_transaction_reports = @q.result.order(id: :desc)
    @all_daily_transaction_reports = @daily_transaction_reports
    @daily_transaction_reports=  @daily_transaction_reports.page(params[:pahe]).per(40)
  end

  # GET /daily_transaction_reports/1 or /daily_transaction_reports/1.json
  def show
  end

  # GET /daily_transaction_reports/new
  def new
    @daily_transaction_report = DailyTransactionReport.new
  end

  # GET /daily_transaction_reports/1/edit
  def edit
  end

  # POST /daily_transaction_reports or /daily_transaction_reports.json
  def create
    # authorize DailyTransactionReport, :manage?

    @daily_transaction_report = DailyTransactionReport.new(daily_transaction_report_params)
    @daily_transaction_report.user_id = current_user.id
    respond_to do |format|
      if @daily_transaction_report.save
        format.html { redirect_to daily_transaction_reports_url, notice: "Daily transaction report was successfully created." }
        format.json { render :show, status: :created, location: @daily_transaction_report }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @daily_transaction_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /daily_transaction_reports/1 or /daily_transaction_reports/1.json
  def update
    respond_to do |format|
      if @daily_transaction_report.update(daily_transaction_report_params)
        format.html { redirect_to daily_transaction_reports_url, notice: "Daily transaction report was successfully updated." }
        format.json { render :show, status: :ok, location: @daily_transaction_report }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @daily_transaction_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /daily_transaction_reports/1 or /daily_transaction_reports/1.json
  def destroy
    @daily_transaction_report.destroy

    respond_to do |format|
      format.html { redirect_to daily_transaction_reports_url, notice: "Daily transaction report was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_daily_transaction_report
      @daily_transaction_report = DailyTransactionReport.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def daily_transaction_report_params
      params.require(:daily_transaction_report).permit(:income_in_usd, :income_in_uzs, :user_id, :created_at)
    end
end
