class ChangeScaleOfTotalColumns < ActiveRecord::Migration[7.0]
  def up
    change_column :sale_from_services, :total_paid, :decimal, precision: 17, scale: 2, default: 0
    change_column :sale_from_services, :total_price, :decimal, precision: 17, scale: 2, default: 0
    change_column :sales, :total_paid, :decimal, precision: 17, scale: 2, default: 0
    change_column :sales, :total_price, :decimal, precision: 17, scale: 2, default: 0
  end

  def down
    change_column :sale_from_services, :total_paid, :decimal, precision: 17, default: 0
    change_column :sale_from_services, :total_price, :decimal, precision: 17, default: 0
    change_column :sales, :total_paid, :decimal, precision: 17, default: 0
    change_column :sales, :total_price, :decimal, precision: 17, default: 0
  end
end
