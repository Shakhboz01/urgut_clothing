class AddWeightToProductCategories < ActiveRecord::Migration[7.0]
  def change
    add_column :product_categories, :weight, :integer, default: 0
  end
end
