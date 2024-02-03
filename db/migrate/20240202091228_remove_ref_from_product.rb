class RemoveRefFromProduct < ActiveRecord::Migration[7.0]
  def change
    remove_reference :products, :product_category
    add_reference :products, :pack
    add_column :packs, :code, :string
    add_column :packs, :barcode, :string
    remove_reference :product_entries, :product
    remove_reference :product_entries, :storage
  end
end
