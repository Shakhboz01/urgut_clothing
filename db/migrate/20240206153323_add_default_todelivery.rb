class AddDefaultTodelivery < ActiveRecord::Migration[7.0]
  def change
    change_column :delivery_from_counterparties, :price_in_usd, :boolean, default: true
  end
end
