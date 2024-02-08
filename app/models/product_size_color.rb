class ProductSizeColor < ApplicationRecord
  belongs_to :color
  belongs_to :size
  belongs_to :pack
  validates_presence_of :amount
  after_create :create_products
  validates :size, presence: true, uniqueness: { scope: [:pack_id], message: "size already exists" }

  def increase_product
    product = pack.products.find_by(size: size)
    product.increment!(:initial_remaining, amount)
  end

  private

  def create_products
    Product.create(
      name: "#{pack.name.split('|')[0]} | #{size.name}" , size: size, color: color, code: pack.code, barcode: pack.barcode, pack: pack
    )
  end
end
