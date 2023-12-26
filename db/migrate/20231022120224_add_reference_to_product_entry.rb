class AddReferenceToProductEntry < ActiveRecord::Migration[7.0]
  def change
    remove_reference :combination_of_local_products, :product_entry, foreign_key: true
    add_reference :product_entries, :delivery_from_counterparty, null: true, foreign_key: true
    add_reference :product_entries, :combination_of_local_product, null: true, foreign_key: true
  end
end
