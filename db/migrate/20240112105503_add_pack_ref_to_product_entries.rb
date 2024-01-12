class AddPackRefToProductEntries < ActiveRecord::Migration[7.0]
  def change
    add_reference :product_entries, :pack, null: false, foreign_key: true
  end
end
