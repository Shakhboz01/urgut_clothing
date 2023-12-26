class AddAmountToProductSell < ActiveRecord::Migration[7.0]
  def change
    add_column :product_sells, :amount, :decimal, default: 0, precision: 15, scale: 2
  end
end
