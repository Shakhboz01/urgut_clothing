class AddRefToProductSells < ActiveRecord::Migration[7.0]
  def change
    add_reference :product_sells, :pack, null: true
    change_column :product_sells, :product_id, :bigint, null: true
  end
end
