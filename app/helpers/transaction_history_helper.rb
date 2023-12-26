module TransactionHistoryHelper
  def check_belonging(transaction_history)
    if !transaction_history.sale_id.nil?
      link_to 'продажи', sale_path(transaction_history.sale)
    elsif !transaction_history.delivery_from_counterparty_id.nil?
      link_to 'покупки товаров', delivery_from_counterparty_path(transaction_history.delivery_from_counterparty)
    elsif !transaction_history.expenditure_id.nil?
      link_to 'расходов', expenditure_path(transaction_history.expenditure)
    end
  end
end
