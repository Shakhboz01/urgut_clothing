class RemoveRefFromProduct < ActiveRecord::Migration[7.0]
  def change
    remove_reference :products, :product_category
  end
end
