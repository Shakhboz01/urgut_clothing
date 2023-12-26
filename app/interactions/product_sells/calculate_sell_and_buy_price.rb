# product initial remaining
# if sell_price is set manually(not 0), then it should not be changed
# if initial true but sell_price is 0 then take the first product entry's sell price
# if initial true && sell_price is 0 && (product entry nil || entry's sell price 0) return error so that user can add a sell price
# prod entry's amount_sold can be greater than its amount, in that case, product oversold and send telegram message

module ProductSells
  class CalculateSellAndBuyPrice < ActiveInteraction::Base
    object :product_sell

    def execute
      amount = product_sell.amount
      return errors.add(:base, "amount cannot be zero") if amount.nil? || amount.zero?

      product = product_sell.product
      response = nil
      first_available_entry = product.product_entries.where("amount > amount_sold").order(id: :desc).last
      if product.initial_remaining <= 0
        return errors.add(:base, "товар #{product.name}, не имеется в складе!") if first_available_entry.nil?

        response = ProductSells::FindProductEntriesUntilAmount.run!(
          product: product,
          amount: amount,
        )
      else
        if (amount <= product.initial_remaining) || first_available_entry.nil?
          sell_price = product_sell.sell_price
          buy_price = product.buy_price.zero? ? first_available_entry&.buy_price : product.buy_price
          return errors.add(:base, "please set buy_price to #{product.name}") if buy_price.nil?

          if sell_price.zero?
            sell_price = product.sell_price.zero? ? first_available_entry&.sell_price : product.sell_price
            sell_price = buy_price if sell_price.nil? && !product_sell.combination_of_local_product.present?
            return errors.add(:base, "please set sell_price to #{product.name}") if sell_price.nil?
          end

          price_data = { '0': { amount: amount, sell_price: sell_price, buy_price: buy_price, service_price: sell_price } }
          response = ProductSells::FindAverageSellAndBuyPrice.run(price_data: price_data)
          return response.result
        elsif amount > product.initial_remaining
          remaining_amount = amount - product.initial_remaining
          response = ProductSells::FindProductEntriesUntilAmount.run(
            product: product,
            amount: remaining_amount,
          )
        end
      end

      response.is_a?(Hash) ? response : response.result
    end
  end
end
