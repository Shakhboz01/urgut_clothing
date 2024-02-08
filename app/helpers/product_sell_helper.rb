module ProductSellHelper
  def calculate_sale_price_in_usd(rate, product_sell)
    if product_sell.price_in_usd
      number_to_currency(product_sell.sell_price * product_sell.amount)
    else
      number_to_currency((product_sell.sell_price / rate) * product_sell.amount)
    end
  end

  def calculate_sale_price_in_uzs(rate, product_sell)
    if product_sell.price_in_usd
      number_to_currency((product_sell.sell_price * rate * product_sell.amount), unit: '')
    else
      number_to_currency(product_sell.sell_price * product_sell.amount, unit: '')
    end
  end
end