class ChangeToBooleanInProviders < ActiveRecord::Migration[6.0] # Use your Rails version
  def up
    change_column :providers, :active, 'boolean USING CAST(active AS boolean)'
  end

  def down
    change_column :providers, :active, :string
  end
end
