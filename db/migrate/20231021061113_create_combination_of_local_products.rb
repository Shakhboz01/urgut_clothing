class CreateCombinationOfLocalProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :combination_of_local_products do |t|
      t.string :comment
      t.integer :status, default: 0
      t.references :product_entry, null: false, foreign_key: true

      t.timestamps
    end
  end
end
