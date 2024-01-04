class CreateDebtOperations < ActiveRecord::Migration[7.0]
  def change
    create_table :debt_operations do |t|
      t.boolean :debt_in_usd, default: true
      t.integer :status, default: 0
      t.decimal :price, precision: 18, scale: 2
      t.references :user, null: false, foreign_key: true
      t.references :debt_user, null: false, foreign_key: true
      t.string :comment

      t.timestamps
    end
  end
end
