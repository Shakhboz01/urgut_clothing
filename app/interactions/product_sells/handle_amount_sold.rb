module ProductSells
  class HandleAmountSold < ActiveInteraction::Base
    object :product
    array :product_entry_ids
    decimal :amount

    def execute
      remaining_amount = amount
      product_entries = ProductEntry.where(id: product_entry_ids).order(:created_at)
      price_data = {}
      # take the last sell and buy price iff product.buy or sell_price is zero
      if product.initial_remaining > 0
        product_sell_price = product.sell_price.zero? ? product_entries.last.sell_price : product.sell_price
        product_buy_price = product.buy_price.zero? ? product_entries.last.buy_price : product.buy_price
        product_service_price = product.sell_price.zero? ? product_entries.last.service_price : product.sell_price
        price_data.merge!({ '0': {
          amount: product.initial_remaining,
          sell_price: product_sell_price,
          service_price: product_service_price,
          buy_price: product_buy_price,
        } })
      end

      product_entries.each do |product_entry|
        difference = product_entry.amount - product_entry.amount_sold
        if difference <= remaining_amount
          price_data.merge!({ "#{product_entry.id}": {
            amount: difference,
            sell_price: product_entry.sell_price,
            buy_price: product_entry.buy_price,
            service_price: product_entry.service_price,
          } })
          remaining_amount -= difference
        else
          price_data.merge!({ "#{product_entry.id}": {
            amount: remaining_amount,
            sell_price: product_entry.sell_price,
            buy_price: product_entry.buy_price,
            service_price: product_entry.service_price,
          } })
          remaining_amount = 0
        end
      end

      if remaining_amount.positive?
        price_data.merge!({ "#{product_entries.last&.id&.to_f}": {
          amount: remaining_amount,
          sell_price: product_entries.last&.sell_price,
          buy_price: product_entries.last&.buy_price,
          service_price: product_entries.last&.service_price,
        } })
      end

      ProductSells::FindAverageSellAndBuyPrice.run!(price_data: price_data.to_h)
    end
  end
end
