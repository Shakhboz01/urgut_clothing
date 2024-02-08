# initial remaining is changable, it can also be negative, but warn if it is a negative
# NOTE sell_price buy price might be 0
class Product < ApplicationRecord
  include ProtectDestroyable

  belongs_to :color
  belongs_to :pack
  belongs_to :size, optional: true
  has_many :product_entries
  has_many :product_remaining_inequalities

  validates :code, presence: true, uniqueness: { scope: [:color_id, :size_id], message: "combination already exists" }

  scope :active, -> { where(:active => true) }
  scope :local, -> { where(:local => true) }

  # after_save :process_initial_remaining_change, if: :saved_change_to_initial_remaining?


  def self.generate_code
    rand(1_000..9_999).to_s
  end

  def self.generate_barcode
    rand(100_00000..999_99999).to_s
  end

  def calculate_product_remaining_in_pack
    psc_amount = pack.product_size_colors.where(size: size, color: color).last.amount
    pack.calculate_product_remaining * psc_amount
  end

  private

  def process_initial_remaining_change
    return if initial_remaining.positive? && !self.product_entries.count.zero?

    # SendMessage.run(message: "Остаток товара(#{name}) = #{initial_remaining}", chat: 'warning')
  end
end
