module HandleSellAndBuyPrice
  extend ActiveSupport::Concern

  included do
    before_save :set_prices
  end

  private

  def set_prices
    byebug
    rate = CurrencyRate.where(finished_at: nil).last.rate
    self.sell_price = sell_price.to_f
    self.buy_price = buy_price.to_f
    if price_in_usd
      self.sell_price_in_usd = sell_price
      self.sell_price_in_uzs = sell_price * rate
      self.price = sell_price * rate
      self.price = sell_price

      if self.attributes.keys.includes?('service_price')
        self.service_price = service_price.to_f

        self.service_price_in_uzs = service_price * rate
        self.service_price_in_usd = service_price
      end
    else
      self.sell_price_in_uzs = sell_price
      self.sell_price_in_usd = sell_price.to_f / rate

      self.price = buy_price
      self.price = buy_price.to_f / rate

      if self.attributes.keys.includes?('service_price')
        self.service_price = service_price.to_f
        self.service_price_in_uzs = service_price
        self.service_price_in_usd = service_price / rate
      end
    end
  end
end
