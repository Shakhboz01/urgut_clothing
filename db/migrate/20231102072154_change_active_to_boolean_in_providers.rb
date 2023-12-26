class ChangeActiveToBooleanInProviders < ActiveRecord::Migration[6.0] # Use your Rails version
  def up
    change_column_default :providers, :active, nil
  end

  def down
    change_column_default :providers, :active, true
  end
end
