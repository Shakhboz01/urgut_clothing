module DebtUserHelper
  def calculate_debt(debt_user, in_usd = false)
    debt_operations = debt_user.debt_operations.price_in_usd
    if in_usd
      diff = debt_operations.price_in_usd.отдача.sum(:price) - debt_operations.price_in_usd.приём.sum(:price)
    else
      diff = debt_operations.price_in_uzs.отдача.sum(:price) - debt_operations.price_in_uzs.приём.sum(:price)
    end

    "<b style='color: #{diff < 0 ? 'red' : 'blue'}'>#{num_to_usd diff}</b>".html_safe
  end
end