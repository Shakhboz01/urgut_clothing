class Pack < ApplicationRecord
  has_many :product_size_colors
  has_many :product_entries
  validates_presence_of :name
  validates_presence_of :code
  attr_accessor :delivery_id

  def product_size_colors_attributes=(product_size_colors_attributes)
    product_size_colors_attributes.each do |i, dog_attributes|
      next if dog_attributes.values.any?(&:empty?)

      size = Size.find_or_create_by(name: dog_attributes[:size])
      dog_attributes[:size_id] = size.id
      dog_attributes.delete('size')
      self.product_size_colors.build(dog_attributes)
    end
  end
end
