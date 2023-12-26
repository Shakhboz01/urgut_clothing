class AddFirstRecordToTransactionHistories < ActiveRecord::Migration[7.0]
  def change
    add_column :transaction_histories, :first_record, :boolean, default: false
  end
end
