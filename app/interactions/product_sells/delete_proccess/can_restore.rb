module ProductSells
  module DeleteProccess
    class CanRestore < ActiveInteraction::Base
      object :pack

      def execute
        pack.products.each do |product|
          psc = pack.product_size_colors.find_by_size_id(product.size_id)
          return errors.add(:base, 'cannot restore') if psc.amount > product.initial_remaining

          next
        end
      end
    end
  end
end
