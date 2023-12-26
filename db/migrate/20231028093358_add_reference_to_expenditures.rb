class AddReferenceToExpenditures < ActiveRecord::Migration[7.0]
  def change
    add_reference :expenditures, :delivery_from_counterparty, null: true, foreign_key: true
  end
end
