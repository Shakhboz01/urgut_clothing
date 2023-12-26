class RemoveDefaultServicePriceFromProductEntries < ActiveRecord::Migration[7.0]
  def change
    change_column_default :product_entries, :service_price, nil
  end
end
