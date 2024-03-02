module ProductSells
  class ExecuteSellByPiece < ActiveInteraction::Base
    decimal :amount
    object :product

    def execute
      product_total_remaining = (product.calculate_product_remaining_in_pack + product.initial_remaining)
      return errors.add(:base, 'Ostatok malo') if amount > product_total_remaining

      should_break_pack = product.initial_remaining < amount
      if should_break_pack
        self.amount = amount - product.initial_remaining
        product.update(initial_remaining: 0) unless product.initial_remaining.zero?
        amount_of_sizes_in_pack = product.pack.product_size_colors.find_by_size_id(product.size.id)&.amount
        return errors.add(:base, 'size not found in pack') if amount_of_sizes_in_pack.nil?

        packs_number_to_break = (amount / amount_of_sizes_in_pack).ceil
        product.pack.break_packs(packs_number_to_break)
      end

      product.decrement!(:initial_remaining, amount)
    end
  end
end