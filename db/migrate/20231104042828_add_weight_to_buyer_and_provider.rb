class AddWeightToBuyerAndProvider < ActiveRecord::Migration[7.0]
  def change
    add_column :providers, :weight, :integer, default: 0
    add_column :buyers, :weight, :integer, default: 0
  end
end
