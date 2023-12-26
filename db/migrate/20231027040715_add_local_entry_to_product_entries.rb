class AddLocalEntryToProductEntries < ActiveRecord::Migration[7.0]
  def change
    add_column :product_entries, :local_entry, :boolean, default: false
    add_column :product_entries, :return, :boolean, default: false
  end
end
