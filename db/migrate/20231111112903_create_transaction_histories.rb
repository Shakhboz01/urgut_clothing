class CreateTransactionHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :transaction_histories do |t|
      t.references :sale, null: true, foreign_key: true
      t.references :sale_from_service, null: true, foreign_key: true
      t.references :sale_from_local_service, null: true, foreign_key: true
      t.references :delivery_from_counterparty, null: true, foreign_key: true
      t.references :expenditure, null: true, foreign_key: true
      t.decimal :price, precision: 17, scale: 2

      t.timestamps
    end
  end
end
