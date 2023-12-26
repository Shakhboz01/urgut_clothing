module HandleCurrency
  extend ActiveSupport::Concern

  included do
    before_save :set_prices
  end

  private

  def set_prices
    rate = CurrencyRate.where(finished_at: nil).last.rate
    self.price = price.to_f
    if paid_in_usd
      self.price_in_usd = price
      self.price_in_uzs = price * rate
    else
      self.price_in_uzs = price
      self.price_in_usd = price.to_f / rate
    end
  end
end
