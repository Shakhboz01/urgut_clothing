class RemoveRefFromProduct < ActiveRecord::Migration[7.0]
  def change
    remove_reference :products, :product_category
    add_reference :products, :pack
    add_column :packs, :code, :string
    add_column :packs, :barcode, :string
  end
end
