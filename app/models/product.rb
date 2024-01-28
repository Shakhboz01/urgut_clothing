# initial remaining is changable, it can also be negative, but warn if it is a negative
# NOTE sell_price buy price might be 0
class Product < ApplicationRecord
  include ProtectDestroyable

  belongs_to :color
  belongs_to :size
  belongs_to :product_category
  has_many :product_entries
  has_many :product_remaining_inequalities

  validates :code, presence: true, uniqueness: { scope: [:color_id, :size_id], message: "combination already exists" }
  validate :consistent_category_for_same_code

  scope :active, -> { where(:active => true) }
  scope :local, -> { where(:local => true) }

  after_save :process_initial_remaining_change, if: :saved_change_to_initial_remaining?


  def self.generate_code
    rand(100_000..999_999).to_s
  end

  def calculate_product_remaining
    remaining_from_entries = product_entries.sum(:amount) - product_entries.sum(:amount_sold)
    remaining_from_entries + initial_remaining
  end

  private

  def process_initial_remaining_change
    return if initial_remaining.positive? && !self.product_entries.count.zero?

    # SendMessage.run(message: "Остаток товара(#{name}) = #{initial_remaining}", chat: 'warning')
  end

  def consistent_category_for_same_code
    if Product.exists?(code: code) && Product.where(code: code).last.product_category_id != product_category_id
      errors.add(:product_category_id, 'Products with the same code should have the same category_id')
    end
  end
end
