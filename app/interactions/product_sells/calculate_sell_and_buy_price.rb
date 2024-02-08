# product initial remaining
# if sell_price is set manually(not 0), then it should not be changed
# if initial true but sell_price is 0 then take the first product entry's sell price
# if initial true && sell_price is 0 && (product entry nil || entry's sell price 0) return error so that user can add a sell price
# prod entry's amount_sold can be greater than its amount, in that case, product oversold and send telegram message

# NOTE: product is accepted as PACK

module ProductSells
  class CalculateSellAndBuyPrice < ActiveInteraction::Base
    object :product_sell
    boolean :sell_by_piece, default: false

    def execute
      quantity = product_sell.pack.product_size_colors.sum(:amount)
      amount = product_sell.amount
      return errors.add(:base, 'amount cannot be zero') if amount.nil? || amount.zero?

      pack = product_sell.pack
      response = nil
      first_available_entry = pack.product_entries.unsold.order(id: :desc).last
      if pack.initial_remaining <= 0 && !first_available_entry.nil?
        response = ProductSells::FindProductEntriesUntilAmount.run!(pack: pack, amount: amount)
      else
        if (amount <= pack.initial_remaining) || first_available_entry.nil?
          price_in_usd = pack.price_in_usd
          sell_price = price_in_usd ? pack.sell_price : pack.sell_price * CurrencyRate.last.rate
          buy_price = pack.buy_price

          if sell_price.zero?
            sell_price = pack.sell_price
            return errors.add(:base, "please set sell_price to #{pack.name}") if sell_price.nil?
          end

          buy_price ||= sell_price - (sell_price * 5 / 100)
          price_data = { '0': { amount: amount, sell_price: sell_price, buy_price: buy_price } }
          response = ProductSells::FindAverageSellAndBuyPrice.run(
            price_data: price_data, price_in_usd: price_in_usd, sell_by_piece: sell_by_piece
          )
          return response.result unless sell_by_piece

          response.result[:average_prices].each do |k, v|
            response.result[:average_prices][k] = v / quantity
          end

          return response.result
        elsif amount > pack.initial_remaining
          remaining_amount = amount - pack.initial_remaining
          response = ProductSells::FindProductEntriesUntilAmount.run(
            pack: pack,
            amount: remaining_amount,
            sell_by_piece: sell_by_piece
          )
        end
      end

      result = response.is_a?(Hash) ? response : response.result

      return result unless sell_by_piece

      result[:average_prices].each do |k, v|
        result[:average_prices][k] = v / quantity
      end

      return result
    end
  end
end
