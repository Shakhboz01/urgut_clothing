class AddReferenceToProductEntries < ActiveRecord::Migration[7.0]
  def change
    add_reference :product_entries, :storage, null: false, foreign_key: true
  end
end
