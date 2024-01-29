class Pack < ApplicationRecord
  has_many :product_size_colors
  has_many :product_entries
end
