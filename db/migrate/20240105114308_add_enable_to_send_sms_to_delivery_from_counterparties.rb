class AddEnableToSendSmsToDeliveryFromCounterparties < ActiveRecord::Migration[7.0]
  def change
    add_column :delivery_from_counterparties, :enable_to_send_sms, :boolean, default: true
    add_column :sales, :enable_to_send_sms, :boolean, default: true
  end
end
