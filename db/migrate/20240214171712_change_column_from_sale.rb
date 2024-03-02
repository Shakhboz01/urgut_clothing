class ChangeColumnFromSale < ActiveRecord::Migration[7.0]
  def change
    change_column :product_sells, :price_in_usd, :boolean, default: true
    change_column :sales, :price_in_usd, :boolean, default: true
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
