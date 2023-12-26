class CreateOwnersOperations < ActiveRecord::Migration[7.0]
  def change
    create_table :owners_operations do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :operation_type, default: 0
      t.boolean :price_in_usd, default: true
      t.decimal :price, precision: 19, scale: 2
      t.bigint :operator_user_id

      t.timestamps
    end
  end
end
