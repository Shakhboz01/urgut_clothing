class AddPriceInUsdToDeliveryFromCounterparties < ActiveRecord::Migration[7.0]
  def change
    add_column :delivery_from_counterparties, :price_in_usd, :boolean, default: false
    add_column :transaction_histories, :price_in_usd, :boolean, default: false
    add_column :sales, :price_in_usd, :boolean, default: false
    add_column :product_sells, :price_in_usd, :boolean, default: false
    add_column :expenditures, :price_in_usd, :boolean, default: false
  end
end
