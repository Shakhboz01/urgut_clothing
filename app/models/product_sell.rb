# product combination usage
# if price_data has a key of `0`, it means from product model, not from prod entry
# increase product initial remaining before_destroy if price data contains 0
class ProductSell < ApplicationRecord
  attr_accessor :initial_remaining
  attr_accessor :remaining_outside_pack
  attr_accessor :barcode
  attr_accessor :rate
  attr_accessor :min_price_in_usd

  belongs_to :sale
  belongs_to :pack
  belongs_to :product, optional: true
  has_one :buyer, through: :sale
  has_one :user, through: :sale
  validates_presence_of :amount
  enum payment_type: %i[наличные карта click предоплата перечисление дригие]
  scope :price_in_uzs, -> { where('price_in_usd = ?', false) }
  scope :price_in_usd, -> { where('price_in_usd = ?', true) }
  before_create :set_prices_and_profit
  before_create :increase_amount_sold # TASK 1
  before_update :set_prices_and_profit
  after_create :increase_total_price
  before_update :change_sell_price
  before_destroy :deccrease_amount_sold # TASK 2
  before_destroy :decrease_total_price

  scope :price_in_uzs, -> { where('price_in_usd = ?', false) }
  scope :price_in_usd, -> { where('price_in_usd = ?', true) }

  private

  def increase_total_price
    sale.increment!(:total_price, (sell_price * amount))
  end

  def decrease_total_price
    return throw(:abort) if !sale.nil? && sale.closed?

    sale.decrement!(:total_price, (sell_price * amount))
  end

  def deccrease_amount_sold
    return throw(:abort) if !sale.nil? && sale.closed?

    if sell_by_piece
      return errors.add(:base, 'product is nil') if product.nil?

      ps = ProductSells::ExecuteDeleteByPiece.run(
        amount: amount,
        product: product
      )

      errors.add(:base, ps.errors.messages) unless ps.valid?
    else
      pack.increment!(:initial_remaining, amount)
    end
  end

  def increase_amount_sold
    if sell_by_piece
      return errors.add(:base, 'product is nil') if product.nil?

      esp = ProductSells::ExecuteSellByPiece.run!(amount: amount, product: product)
      return errors.add(:base, esp.errors.messages) unless esp.valid?
    else
      pack.decrement!(:initial_remaining, amount)
    end
  end

  def set_prices_and_profit
    self.buy_price = pack.buy_price
    profit = sell_price - buy_price
    self.total_profit = profit * amount
  end

  def change_sell_price
    return if price_in_usd == price_in_usd_was

    rate = CurrencyRate.last.rate
    if price_in_usd_was == false && price_in_usd == true
      self.sell_price = sell_price / rate
    elsif price_in_usd_was == true && price_in_usd == false
      self.sell_price = sell_price * rate
    end
  end
end
