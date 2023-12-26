class AddReferenceToExpenditureAndProductEntry < ActiveRecord::Migration[7.0]
  def change
    add_reference :product_entries, :sale_from_local_service, null: true, foreign_key: true
  end
end
