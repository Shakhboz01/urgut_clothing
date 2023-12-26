class AddSaleIdsToExpenditure < ActiveRecord::Migration[7.0]
  def change
    add_column :expenditures, :sale_ids, :string
  end
end
