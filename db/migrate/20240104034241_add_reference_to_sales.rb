class AddReferenceToSales < ActiveRecord::Migration[7.0]
  def change
    add_reference :delivery_from_counterparties, :product_category, null: true, foreign_key: true
  end
end
