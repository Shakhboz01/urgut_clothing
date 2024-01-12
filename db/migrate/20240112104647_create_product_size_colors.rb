class CreateProductSizeColors < ActiveRecord::Migration[7.0]
  def change
    create_table :product_size_colors do |t|
      t.references :color, null: false, foreign_key: true
      t.references :size, null: false, foreign_key: true
      t.integer :amount
      t.references :pack, null: false, foreign_key: true

      t.timestamps
    end
  end
end
