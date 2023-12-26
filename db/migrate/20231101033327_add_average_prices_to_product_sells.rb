class AddAveragePricesToProductSells < ActiveRecord::Migration[7.0]
  def change
    add_column :product_sells, :average_prices, :jsonb
  end
end
