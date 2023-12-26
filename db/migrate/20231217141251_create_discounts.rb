class CreateDiscounts < ActiveRecord::Migration[7.0]
  def change
    create_table :discounts do |t|
      t.references :sale, null: false, foreign_key: true
      t.boolean :verified, default: false
      t.boolean :price_in_usd, default: false
      t.decimal :price, precision: 15, scale: 2
      t.string :comment
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
