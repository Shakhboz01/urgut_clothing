# product combination usage
# if price_data has a key of `0`, it means from product model, not from prod entry
# increase product initial remaining before_destroy if price data contains 0
class ProductSell < ApplicationRecord
  belongs_to :combination_of_local_product, optional: true
  belongs_to :sale_from_local_service, optional: true
  belongs_to :sale
  belongs_to :sale_from_service, optional: true
  belongs_to :product
  has_one :buyer, through: :sale
  has_one :user, through: :sale
  validates_presence_of :amount
  enum payment_type: %i[наличные карта click дригие]
  validate :handle_amount_sold
  validate :verify_combination_is_not_closed
  scope :price_in_uzs, -> { where('price_in_usd = ?', false) }
  scope :price_in_usd, -> { where('price_in_usd = ?', true) }
  before_create :increase_amount_sold
  before_create :set_prices_and_profit
  after_create :update_sale_currency
  after_create :increase_total_price
  before_destroy :deccrease_amount_sold
  before_destroy :decrease_total_price

  private

  def increase_total_price
    if !sale_from_service.nil?
      sale_from_service.increment!(:total_price, (sell_price * amount))
      sale_from_service.increment!(:total_paid, (sell_price * amount))
    elsif !sale_from_local_service.nil?
      sale_from_local_service.increment!(:total_price, (sell_price * amount))
      sale_from_local_service.increment!(:total_paid, (sell_price * amount))
    elsif !sale.nil?
      sale.increment!(:total_price, (sell_price * amount))
      sale.increment!(:total_paid, (sell_price * amount))
    end
  end

  def decrease_total_price
    if !sale_from_service.nil?
      sale_from_service.decrement!(:total_price, (sell_price * amount))
      sale_from_service.decrement!(:total_paid, (sell_price * amount))
    elsif !sale_from_local_service.nil?
      sale_from_local_service.decrement!(:total_price, sell_price)
      sale_from_local_service.decrement!(:total_paid, sell_price)
    elsif !sale.nil?
      sale.decrement!(:total_price, sell_price)
      sale.decrement!(:total_paid, sell_price)
    end
  end

  def deccrease_amount_sold
    return throw(:abort) if !combination_of_local_product.nil? && combination_of_local_product.closed?
    return throw(:abort) if !sale_from_local_service.nil? && sale_from_local_service.closed?
    return throw(:abort) if !sale_from_service.nil? && sale_from_service.closed?
    return throw(:abort) if !sale.nil? && sale.closed?

    price_data.each do |data|
      if data[0].to_i.zero?
        product.increment!(:initial_remaining, data[1]["amount"].to_f) and next
      end

      ProductEntry.find(data[0]).decrement!(:amount_sold, data[1]["amount"].to_f)
    end
  end

  def handle_amount_sold
    return if self.persisted? || !new_record? || product.nil?

    ps_validation = ProductSells::CalculateSellAndBuyPrice.run(
      product_sell: self,
    )

    return errors.add(:base, ps_validation.errors.messages.values.flatten[0]) unless ps_validation.valid?

    self.price_data = ps_validation.result[:price_data]
    self.average_prices = ps_validation.result[:average_prices]
  end

  def increase_amount_sold
    price_data.each do |data|
      if data[0].to_i.zero?
        product.decrement!(:initial_remaining, data[1]["amount"].to_f) and next
      end

      ProductEntry.find(data[0].to_i).increment!(:amount_sold, data[1]["amount"].to_f)
    end
  end

  def set_prices_and_profit
    self.price_in_usd = product.price_in_usd
    self.buy_price = average_prices["average_buy_price"]
    if [combination_of_local_product, sale_from_service, sale_from_local_service].any?(&:present?)
      self.sell_price = average_prices["average_buy_price"]
    else
      self.sell_price = (sell_price.nil? || sell_price.zero?) ? average_prices["average_sell_price"] : sell_price
    end

    profit = sell_price - buy_price
    self.total_profit = profit * amount
  end

  def verify_combination_is_not_closed
    return errors.add(:base, "cannot be edited/created") if !combination_of_local_product.nil? && combination_of_local_product.closed?
    return errors.add(:base, "cannot be edited/created") if !sale_from_service.nil? && sale_from_service.closed?

    errors.add(:base, "cannot be edited/created") if !sale_from_local_service.nil? && sale_from_local_service.closed?
  end

  def update_sale_currency
    return if sale.nil? || sale.price_in_usd == price_in_usd

    sale.update(price_in_usd: price_in_usd)
  end
end
