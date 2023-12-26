class AddPriceInPercentageToProductEntries < ActiveRecord::Migration[7.0]
  def change
    add_column :product_entries, :price_in_percentage, :decimal, precision: 5, scale: 2
  end
end
