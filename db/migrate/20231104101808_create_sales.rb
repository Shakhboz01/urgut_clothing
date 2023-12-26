class CreateSales < ActiveRecord::Migration[7.0]
  def change
    create_table :sales do |t|
      t.decimal :total_paid, precision: 17, scale: 0
      t.integer :payment_type, default: 0
      t.references :buyer, null: false, foreign_key: true
      t.decimal :total_price, precision: 17, scale: 0, default: 0
      t.string :comment
      t.references :user, null: true, foreign_key: true
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
