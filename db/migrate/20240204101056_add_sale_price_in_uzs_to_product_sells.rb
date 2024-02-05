class AddSalePriceInUzsToProductSells < ActiveRecord::Migration[7.0]
  def change
    add_column :product_sells, :sell_price_in_uzs, :decimal, precision: 17, scale: 2
    add_column :packs, :sell_price, :decimal, precision: 17, scale: 2
    add_column :packs, :buy_price, :decimal, precision: 17, scale: 2
    add_column :packs, :price_in_usd, :boolean, default: true
  end
end
