class CreateProductRemainingInequalities < ActiveRecord::Migration[7.0]
  def change
    create_table :product_remaining_inequalities do |t|
      t.references :product, null: false, foreign_key: true
      t.decimal :amount
      t.decimal :previous_amount
      t.string :reason
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
