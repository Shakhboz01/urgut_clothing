class ChangeDefaultValue < ActiveRecord::Migration[7.0]
  def change
    change_column :product_size_colors, :amount, :integer, :default => 1
  end
end
