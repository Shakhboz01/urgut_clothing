class CreateBuyers < ActiveRecord::Migration[7.0]
  def change
    create_table :buyers do |t|
      t.string :name
      t.string :phone_number
      t.string :comment
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
