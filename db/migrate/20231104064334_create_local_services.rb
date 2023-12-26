class CreateLocalServices < ActiveRecord::Migration[7.0]
  def change
    create_table :local_services do |t|
      t.decimal :price, precision: 16, scale: 2
      t.string :comment
      t.references :sale_from_local_service, null: false, foreign_key: true
      t.references :user, null: true, foreign_key: true

      t.timestamps
    end
  end
end
