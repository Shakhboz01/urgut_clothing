class ChangeColumnOfSale < ActiveRecord::Migration[7.0]
  def up
    change_column :product_sells, :sell_price, :decimal, precision: 18, scale: 6
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end

  def down
    change_column :product_sells, :sell_price, :decimal, precision: 15, scale: 2
  end
end
