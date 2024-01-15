# total paid might be null, it means provider paid fully at once
# ignored service_price
class ProductEntry < ApplicationRecord
  attr_accessor :product_code
  attr_accessor :product_category

  belongs_to :delivery_from_counterparty
  has_one :provider, through: :delivery_from_counterparty
  has_one :user, through: :delivery_from_counterparty
  belongs_to :product, optional: true
  belongs_to :pack

  validates :amount, comparison: { greater_than: 0 }
  validates :sell_price, :buy_price, comparison: { greater_than_or_equal_to: 0 }
  validates :sell_price, comparison: { greater_than_or_equal_to: :buy_price }
  validates_presence_of :buy_price

  before_validation :varify_delivery_from_counterparty_is_not_closed
  before_destroy :varify_delivery_from_counterparty_is_not_closed
  before_create :increase_product_amount
  after_create :update_delivery_currency

  scope :paid_in_uzs, -> { where('paid_in_usd = ?', false) }
  scope :paid_in_usd, -> { where('paid_in_usd = ?', true) }

  private

  def varify_delivery_from_counterparty_is_not_closed
    throw(:abort) if delivery_from_counterparty.closed? && sell_price == sell_price_before_last_save && amount >= amount_sold
    delivery_from_counterparty.decrement!(:total_price, buy_price)
    InitialRemainingBasedOnPack.run(code: product_code, pack: pack, action: :destroy, product_entry_amount: amount)
  end

  def update_delivery_currency
    return if delivery_from_counterparty.price_in_usd == paid_in_usd

    delivery_from_counterparty.update(price_in_usd: paid_in_usd)
  end

  def increase_product_amount
    InitialRemainingBasedOnPack.run(code: product_code, pack: pack, product_entry_amount: amount)
  end
end
