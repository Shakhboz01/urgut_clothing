module ProductSells
  class HandleAmountSold < ActiveInteraction::Base
    object :pack
    array :product_entry_ids
    decimal :amount

    def execute
      rate = CurrencyRate.last.rate
      remaining_amount = amount
      product_entries = ProductEntry.where(id: product_entry_ids).order(:created_at)
      price_data = {}
      set_prices_in_usd = nil
      # take the last sell and buy price iff product.buy or sell_price is zero
      if pack.initial_remaining > 0
        set_prices_in_usd = pack.price_in_usd
        product_sell_price = pack.sell_price.zero? ? product_entries.last.sell_price : pack.sell_price
        product_buy_price = pack.buy_price.zero? ? product_entries.last.buy_price : pack.buy_price
        price_data.merge!({ '0': {
          amount: pack.initial_remaining,
          sell_price: product_sell_price,
          buy_price: product_buy_price
        } })
      end

      product_entries.each do |product_entry|
        set_prices_in_usd ||= product_entry.paid_in_usd
        sell_price = nil
        buy_price = nil

        if set_prices_in_usd && !product_entry.paid_in_usd
          sell_price = product_entry.sell_price / rate
          buy_price = product_entry.buy_price / rate
        elsif !set_prices_in_usd && product_entry.paid_in_usd
          sell_price = rate * product_entry.sell_price
          buy_price = rate * product_entry.buy_price
        else
          sell_price = product_entry.sell_price
          buy_price = product_entry.buy_price
        end

        difference = product_entry.amount - product_entry.amount_sold
        if difference <= remaining_amount
          price_data.merge!({ "#{product_entry.id}": {
            amount: difference,
            sell_price: sell_price,
            buy_price: buy_price
          } })
          remaining_amount -= difference
        else
          price_data.merge!({ "#{product_entry.id}": {
            amount: remaining_amount,
            sell_price: sell_price,
            buy_price: buy_price,
          } })
          remaining_amount = 0
        end
      end

      if remaining_amount.positive?
        sell_price = nil
        buy_price = nil
        if set_prices_in_usd && !product_entry.paid_in_usd
          sell_price = product_entry.sell_price / rate
          buy_price = product_entry.buy_price / rate
        elsif !set_prices_in_usd && product_entry.paid_in_usd
          sell_price = rate * product_entry.sell_price
          buy_price = rate * product_entry.buy_price
        else
          sell_price = product_entry.sell_price
          buy_price = product_entry.buy_price
        end

        price_data.merge!({ "#{product_entries.last&.id&.to_f}": {
          amount: remaining_amount,
          sell_price: sell_price,
          buy_price: buy_price,
        } })
      end
      ProductSells::FindAverageSellAndBuyPrice.run!(price_data: price_data.to_h, rate: rate, price_in_usd: set_prices_in_usd)
    end
  end
end
