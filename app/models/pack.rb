class Pack < ApplicationRecord
  has_many :product_size_colors
  has_many :product_entries
  validates_presence_of :sell_price
  validates :code, presence: true, uniqueness: { scope: [:name], message: "combination already exists" }
  validates :name, presence: true, uniqueness: { scope: [:code], message: "combination already exists" }
  before_validation :reset_name
  before_create :set_buy_price

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

  def calculate_product_remaining
    remaining_from_entries = product_entries.sum(:amount) - product_entries.sum(:amount_sold)
    remaining_from_entries + initial_remaining
  end

  private

  def set_buy_price
    return unless buy_price.nil?

    self.buy_price = sell_price - (sell_price * 5 / 100)
  end

  def reset_name
    size_names = ''
    product_size_colors.each do |product_size_color|
      size = product_size_color.size.name
      product_size_color.amount.times do
        size_names << " #{size}"
      end
    end

    self.name = "#{name} | #{size_names}"
  end
end
