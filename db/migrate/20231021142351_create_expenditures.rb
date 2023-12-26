class CreateExpenditures < ActiveRecord::Migration[7.0]
  def change
    create_table :expenditures do |t|
      t.references :combination_of_local_product, null: true, foreign_key: true
      t.decimal :price, default: 0
      t.decimal :total_paid
      t.integer :expenditure_type
      t.integer :payment_type, default: 0

      t.timestamps
    end
  end
end
