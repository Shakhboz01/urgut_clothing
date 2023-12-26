class CreateSalaries < ActiveRecord::Migration[7.0]
  def change
    create_table :salaries do |t|
      t.boolean :prepayment
      t.date :month, default: Date.current
      t.references :team, null: true, foreign_key: true
      t.references :user, null: true, foreign_key: true
      t.decimal :price, precision: 10, scale: 2
      t.integer :payment_type, default: 0

      t.timestamps
    end
  end
end
