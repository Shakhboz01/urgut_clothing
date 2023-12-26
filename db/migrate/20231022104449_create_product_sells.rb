class CreateProductSells < ActiveRecord::Migration[7.0]
  def change
    create_table :product_sells do |t|
      t.references :combination_of_local_product, null: true, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.decimal :buy_price, precision: 16, scale: 2, default: 0
      t.decimal :sell_price, precision: 16, scale: 2, default: 0
      t.decimal :total_profit, default: 0
      t.jsonb :price_data

      t.timestamps
    end
  end
end
