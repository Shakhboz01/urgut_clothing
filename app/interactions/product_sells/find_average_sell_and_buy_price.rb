module ProductSells
  class FindAverageSellAndBuyPrice < ActiveInteraction::Base
    hash :price_data, strip: false

    def execute
      total_sell_price = 0
      total_buy_price = 0
      total_amount = 0
      total_service_price = 0

      price_data.each do |id, data|
        next if data["amount"].to_i.zero?

        amount = data["amount"].to_i
        sell_price = data["sell_price"].to_f
        service_price = data["service_price"].to_f
        buy_price = data["buy_price"].to_f

        total_sell_price += sell_price * amount
        total_service_price += service_price * amount
        total_buy_price += buy_price * amount
        total_amount += amount
      end

      average_service_price = total_service_price / total_amount
      average_sell_price = total_sell_price / total_amount
      average_buy_price = total_buy_price / total_amount

      return {
               average_prices: {
                 average_sell_price: average_sell_price,
                 average_buy_price: average_buy_price,
                 average_service_price: average_service_price,
               },
               price_data: price_data,
             }
    end
  end
end
