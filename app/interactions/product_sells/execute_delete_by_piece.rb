module ProductSells
  class ExecuteDeleteByPiece < ActiveInteraction::Base
    integer :amount
    object :product

    def execute
      amount_of_sizes_in_pack = product.pack.product_size_colors.find_by_size_id(product.size.id)&.amount
      product.increment!(:initial_remaining, amount)
      return errors.add(:base, 'size not found in pack') if amount_of_sizes_in_pack.nil?

      packs_number_to_restore = (product.initial_remaining / amount_of_sizes_in_pack).floor

      restored_amount = ProductSells::DeleteProccess::CalculateRestoredPack.run(
        product: product,
        packs_number_to_restore: packs_number_to_restore
      )
      return errors.add(:base, restored_amount.errors.messages) unless restored_amount.valid?
    end
  end
end
