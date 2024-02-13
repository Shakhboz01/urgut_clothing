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
  before_validation :handle_amount_sold
  before_create :set_prices_and_profit
  before_create :increase_amount_sold # TASK 1
  before_update :set_prices_and_profit
  after_create :increase_total_price
  before_destroy :deccrease_amount_sold # TASK 2
  before_destroy :decrease_total_price

  scope :price_in_uzs, -> { where('price_in_usd = ?', false) }
  scope :price_in_usd, -> { where('price_in_usd = ?', true) }

  private

  def increase_total_price
    sale.increment!(:total_price, (sell_price * amount))
  end

  def decrease_total_price
    sale.calculate_total_price
  end

  def deccrease_amount_sold
    return throw(:abort) if !sale.nil? && sale.closed?

    # TODO: consider sell_by piece
    if sell_by_piece
      return errors.add(:base, 'product is nil') if product.nil?

      ps = ProductSells::ExecuteDeleteByPiece.run(
        amount: amount,
        product: product
      )
      byebug
      errors.add(:base, ps.errors.messages) unless ps.valid?
    else
      price_data.each do |data|
        if data[0].to_i.zero?
          pack.increment!(:initial_remaining, data[1]["amount"].to_f) and next
        end

        pe = ProductEntry.find_by(id: data[0])
        return unless pe

        pe.decrement!(:amount_sold, data[1]["amount"].to_f)
      end
    end
  end

  def handle_amount_sold
    return if self.persisted? || !new_record?
    return errors.add(:base, 'product is nil') if product.nil? && sell_by_piece

    ps_validation = ProductSells::CalculateSellAndBuyPrice.run(product_sell: self, sell_by_piece: sell_by_piece)

    return errors.add(:base, ps_validation.errors.messages.values.flatten[0]) unless ps_validation.valid?

    self.price_data = ps_validation.result[:price_data]
    self.average_prices = ps_validation.result[:average_prices]
    self.price_in_usd = ps_validation.result[:price_in_usd]
  end

  def increase_amount_sold
    # TODO: consider sell_by piece
    if sell_by_piece
      return errors.add(:base, 'product is nil') if product.nil?

      esp = ProductSells::ExecuteSellByPiece.run!(
        amount: amount,
        product: product
      )
      return errors.add(:base, esp.errors.messages) unless esp.valid?
    else
      price_data.each do |data|
        if data[0].to_i.zero?
          pack.decrement!(:initial_remaining, data[1]['amount'].to_f) and next
        end

        ProductEntry.find(data[0].to_i).increment!(:amount_sold, data[1]["amount"].to_f)
      end
    end
  end

  def set_prices_and_profit
    if new_record?
      # NOTE: that delivery's price_in_usd should be true y default
      self.buy_price = average_prices["average_buy_price_in_usd"]
      self.sell_price = sell_price
      self.price_in_usd = true
    else
      return if price_in_usd == price_in_usd_was

      rate = CurrencyRate.last.rate
      if price_in_usd
        self.buy_price = average_prices["average_buy_price_in_usd"]
        self.sell_price = sell_price / rate
      else
        self.buy_price = average_prices["average_buy_price_in_uzs"]
        self.sell_price = sell_price * rate
      end
    end

    profit = sell_price - buy_price
    self.total_profit = profit * amount
  end
end
