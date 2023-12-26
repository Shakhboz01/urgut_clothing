class AddWithImageFieldToExpenditures < ActiveRecord::Migration[7.0]
  def change
    add_column :expenditures, :with_image, :boolean, default: false
    add_column :delivery_from_counterparties, :with_image, :boolean, default: false
  end
end
