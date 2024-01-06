class PagesController < ApplicationController
  def main_page
    # TODO include discount when calculating a remaining balance
    @buyers = Buyer.all.order(active: :desc)
    @providers = Provider.all.order(active: :desc)
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

  def admin_page
    authorize PagesController, :access?

    @q = DeliveryFromCounterparty.ransack(params[:q])
    @delivery_from_counterparties = @q.result
    @product_categories = ProductCategory.where(weight: 0)
    @local_category_info = []
    @product_categories.each do |product_category|
      money_given_in_usd =
        @delivery_from_counterparties.where(product_category_id: product_category.id)
                                     .price_in_usd.sum(:total_paid)
      money_given_in_uzs =
        @delivery_from_counterparties.where(product_category_id: product_category.id)
                                     .price_in_uzs.sum(:total_paid)
      product_taken_in_usd =
        @delivery_from_counterparties.where(product_category_id: product_category.id)
                                     .price_in_usd.sum(:total_price)
      product_taken_in_uzs =
        @delivery_from_counterparties.where(product_category_id: product_category.id)
                                     .price_in_usd.sum(:total_price)
      overall = {
        category: product_category.name,
        money_given_in_usd: money_given_in_usd,
        money_given_in_uzs: money_given_in_uzs,
        product_taken_in_usd: product_taken_in_usd,
        product_taken_in_uzs: product_taken_in_uzs,
        difference_in_usd: money_given_in_usd - product_taken_in_usd,
        difference_in_uzs: money_given_in_uzs - product_taken_in_uzs
      }
      @local_category_info.push(overall)
    end

    @import_category_info = []
    import_product_category = ProductCategory.find_by(weight: 1)
    product_taken_in_usd =
      @delivery_from_counterparties.where(product_category_id: import_product_category.id)
                                   .price_in_usd.sum(:total_price)
    money_given_in_usd =
      @delivery_from_counterparties.where(product_category_id: import_product_category.id)
                                   .price_in_usd.sum(:total_paid)
    @import_category_info.push({
      category: import_product_category.name,
      money_given_in_usd: money_given_in_usd,
      product_taken_in_usd: product_taken_in_usd,
      difference_in_usd: money_given_in_usd - product_taken_in_usd
    })
  end
end
