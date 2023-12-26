class CreateDeliveryFromCounterparties < ActiveRecord::Migration[7.0]
  def change
    create_table :delivery_from_counterparties do |t|
      t.decimal :total_price, precision: 16, scale: 2, default: 0
      t.decimal :total_paid
      t.integer :payment_type, default: 0
      t.string :comment
      t.integer :status, default: 0
      t.references :provider, null: true, foreign_key: true

      t.timestamps
    end
  end
end
