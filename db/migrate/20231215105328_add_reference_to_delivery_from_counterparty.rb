class AddReferenceToDeliveryFromCounterparty < ActiveRecord::Migration[7.0]
  def change
    add_reference :delivery_from_counterparties, :user, null: false, foreign_key: true
  end
end
