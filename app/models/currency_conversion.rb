class CurrencyConversion < ApplicationRecord
  belongs_to :user
  validates_presence_of :rate
  before_create :set_price

  private

  def set_price
    if to_uzs
      self.price_in_uzs = rate * price_in_usd
    else
      self.price_in_uzs = price_in_usd
      self.price_in_usd = price_in_usd / rate
    end
  end
end
