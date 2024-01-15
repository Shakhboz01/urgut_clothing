class Pack < ApplicationRecord
  validates_uniqueness_of :name
  has_many :product_size_colors
  has_many :product_entries
end
