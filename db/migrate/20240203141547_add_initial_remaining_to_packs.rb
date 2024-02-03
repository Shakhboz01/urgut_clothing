class AddInitialRemainingToPacks < ActiveRecord::Migration[7.0]
  def change
    add_column :packs, :initial_remaining, :integer, default: 0
  end
end
