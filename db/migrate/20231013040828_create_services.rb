class CreateServices < ActiveRecord::Migration[7.0]
  def change
    create_table :services do |t|
      t.string :name
      t.integer :unit
      t.decimal :price, precision: 15, scale: 2, default: 0
      t.boolean :active, default: true
      t.references :user, null: false, foreign_key: true
      t.integer :team_fee_in_percent

      t.timestamps
    end
  end
end
