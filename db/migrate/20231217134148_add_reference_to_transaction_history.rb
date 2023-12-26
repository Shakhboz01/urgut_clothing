class AddReferenceToTransactionHistory < ActiveRecord::Migration[7.0]
  def change
    add_reference :transaction_histories, :user, null: true, foreign_key: true
  end
end
