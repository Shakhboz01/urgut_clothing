class CreateProviders < ActiveRecord::Migration[7.0]
  def change
    create_table :providers do |t|
      t.string :name
      t.string :phone_number
      t.string :comment
      t.string :active, default: true

      t.timestamps
    end
  end
end
