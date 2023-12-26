class AddReferenceFromSaleFromServiceToProductSells < ActiveRecord::Migration[7.0]
  def change
    add_reference :product_sells, :sale_from_service, null: true, foreign_key: true
  end
end
