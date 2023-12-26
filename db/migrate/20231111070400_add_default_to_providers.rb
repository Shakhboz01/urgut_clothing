class AddDefaultToProviders < ActiveRecord::Migration[7.0]
  def change
    def up
      change_column :providers, :active, default: true
    end

    def down
      change_column :providers, :active
    end
  end
end
