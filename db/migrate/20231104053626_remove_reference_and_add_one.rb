class RemoveReferenceAndAddOne < ActiveRecord::Migration[7.0]
  def change
    remove_reference :product_entries, :sale_from_local_service, null: true, foreign_key: true
    add_reference :product_sells, :sale_from_local_service, null: true, foreign_key: true
  end
end
