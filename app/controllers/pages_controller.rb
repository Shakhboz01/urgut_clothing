class PagesController < ApplicationController
  def main_page
    # TODO include discount when calculating a remaining balance
    @buyers = Buyer.all.select { |buyer| buyer.calculate_debt_in_usd > 0 || buyer.calculate_debt_in_uzs > 0 }
    @providers = Provider.all.select { |provider| provider.calculate_debt_in_usd > 0 || provider.calculate_debt_in_uzs > 0 }
    @delivery_from_counterparties =
      DeliveryFromCounterparty.where('created_at >= ?', DateTime.current.beginning_of_day)
                              .or(DeliveryFromCounterparty.unpaid)
                              .order(created_at: :desc)
    @expenditures = Expenditure.where('created_at >= ?', DateTime.current.beginning_of_day)
                               .or(Expenditure.unpaid).order(created_at: :desc)
    @sales = Sale.where('created_at >= ?', DateTime.current.beginning_of_day)
                 .or(Sale.unpaid).order(created_at: :desc)

    unless params.dig(:q, :created_at_end_of_day_lteq)
      params[:q] ||= {}
      params[:q][:created_at_end_of_day_lteq] = DateTime.current.end_of_day
    end
    unless params.dig(:q, :created_at_gteq)
      params[:q] ||= {}
      params[:q][:created_at_gteq] = DateTime.current.beginning_of_day
    end

    @q = TransactionHistory.ransack(params[:q])
    sales = Sale.where('created_at >= ?', params[:q][:created_at_gteq])
               .where('created_at <= ?', params[:q][:created_at_end_of_day_lteq])
    @sales_in_usd = sales.price_in_usd
    @sales_in_uzs = sales.price_in_uzs

    delivery_from_counterparties =
      DeliveryFromCounterparty.where('created_at >= ?', params[:q][:created_at_gteq])
                              .where('created_at <= ?', params[:q][:created_at_end_of_day_lteq])
    @delivery_from_counterparties_in_usd = delivery_from_counterparties.price_in_usd
    @delivery_from_counterparties_in_uzs = delivery_from_counterparties.price_in_uzs

    expenditures =
      Expenditure.where('created_at >= ?', params[:q][:created_at_gteq])
                 .where('created_at <= ?', params[:q][:created_at_end_of_day_lteq])
    @expenditures_in_usd = expenditures.price_in_usd
    @expenditures_in_uzs = expenditures.price_in_uzs

    @total_salary = Salary.where('created_at >= ?', params[:q][:created_at_gteq])
                          .where('created_at <= ?', params[:q][:created_at_end_of_day_lteq])
  end

  def define_sale_destination; end

  def shortcuts; end

  def daily_report
    DailyReport.run
    respond_to do |format|
      format.json { render json: {success: true}, status: :ok }
      format.html { redirect_to request.referrer || root_path }
    end
  end
end
