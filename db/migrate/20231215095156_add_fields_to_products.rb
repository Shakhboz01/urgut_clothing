class AddFieldsToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :price_in_usd, :boolean, default: false
  end
end
