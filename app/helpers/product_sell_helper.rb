module ProductSellHelper
  def calculate_sale_price_in_usd(rate, product_sell)
    if product_sell.price_in_usd
      number_to_currency(product_sell.sell_price)
    else
      number_to_currency(product_sell.sell_price / rate)
    end
  end

  def calculate_sale_price_in_uzs(rate, product_sell)
    if product_sell.price_in_usd
      number_to_currency((product_sell.sell_price * rate), unit: '')
    else
      number_to_currency(product_sell.sell_price, unit: '')
    end
  end
end