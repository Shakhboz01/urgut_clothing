class AddPaymentTypeToTransactionHistories < ActiveRecord::Migration[7.0]
  def change
    add_column :transaction_histories, :payment_type, :integer, default: 0
  end
end
