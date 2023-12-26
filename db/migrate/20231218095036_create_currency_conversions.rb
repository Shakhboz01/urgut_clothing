class CreateCurrencyConversions < ActiveRecord::Migration[7.0]
  def change
    create_table :currency_conversions do |t|
      t.decimal :rate, precision: 9, scale: 2
      t.boolean :to_uzs, default: true
      t.references :user, null: false, foreign_key: true
      t.decimal :price_in_uzs, precision: 18, scale: 2
      t.decimal :price_in_usd, precision: 18, scale: 2

      t.timestamps
    end
  end
end
