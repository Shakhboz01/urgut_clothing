class RemoveTotalExpenditureFromSaleFromLocalServices < ActiveRecord::Migration[7.0]
  def change
    remove_column :sale_from_local_services, :total_expenditure
  end
end
