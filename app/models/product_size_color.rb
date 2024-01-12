class ProductSizeColor < ApplicationRecord
  belongs_to :color
  belongs_to :size
  belongs_to :pack
end
