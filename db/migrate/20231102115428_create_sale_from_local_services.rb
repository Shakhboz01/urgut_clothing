class CreateSaleFromLocalServices < ActiveRecord::Migration[7.0]
  def change
    create_table :sale_from_local_services do |t|
      t.decimal :total_price, precision: 18, scale: 2, default: 0
      t.decimal :total_paid, precision: 18, scale: 2
      t.string :coment
      t.references :buyer, null: false, foreign_key: true
      t.integer :payment_type, default: 0
      t.integer :status, default: 0
      t.decimal :total_expenditure, precision: 18, scale: 2, default: 0
      t.references :user, null: true, foreign_key: true

      t.timestamps
    end
  end
end
