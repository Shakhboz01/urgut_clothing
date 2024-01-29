class ProductSizeColor < ApplicationRecord
  belongs_to :color
  belongs_to :size
  belongs_to :pack
  validates_presence_of :amount
end
