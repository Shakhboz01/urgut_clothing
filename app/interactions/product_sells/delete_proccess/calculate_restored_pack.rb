module ProductSells
  module DeleteProccess
    class CalculateRestoredPack < ActiveInteraction::Base
      object :product
      integer :packs_number_to_restore

      def execute
        packs_number_to_restore.times do
          can_restore = ProductSells::DeleteProccess::CanRestore.run(
            pack: product.pack
          )
          return unless can_restore.valid?

          ProductSells::DeleteProccess::ExecuteRestore.run(
            pack: product.pack
          )
        end
      end
    end
  end
end
