module ProductSells
  module DeleteProccess
    class ExecuteRestore < ActiveInteraction::Base
      object :pack

      def execute
        pack.products.each do |product|
          amount_to_decrement = pack.product_size_colors.find_by_size_id(product.size_id).amount
          product.decrement!(:initial_remaining, amount_to_decrement)
        end

        pack.increment!(:initial_remaining, 1)
      end
    end
  end
end
