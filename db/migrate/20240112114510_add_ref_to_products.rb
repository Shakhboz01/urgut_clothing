class AddRefToProducts < ActiveRecord::Migration[7.0]
  def change
    add_reference :products, :color, null: false, foreign_key: true
    add_reference :products, :size, null: false, foreign_key: true
  end
end