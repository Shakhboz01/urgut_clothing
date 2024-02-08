class AddSellByPieceToProductSells < ActiveRecord::Migration[7.0]
  def change
    add_column :product_sells, :sell_by_piece, :boolean, default: false
  end
end
