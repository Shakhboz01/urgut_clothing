class Provider < ApplicationRecord
  include ProtectDestroyable

  attr_accessor :debt_in_usd
  attr_accessor :debt_in_uzs

  has_many :delivery_from_counterparties
  validates_presence_of :name
  validates_uniqueness_of :name
  scope :active, -> { where(:active => true) }
  before_create :set_active
  after_create :set_debt

  def calculate_debt_in_usd
    delivery_from_counterparties.price_in_usd.sum(:total_price) - delivery_from_counterparties.price_in_usd.sum(:total_paid)
  end

  def calculate_debt_in_uzs
    delivery_from_counterparties.price_in_uzs.sum(:total_price) - delivery_from_counterparties.price_in_uzs.sum(:total_paid)
  end

  private

  def set_active
    self.active = true
  end

  def set_debt
    unless debt_in_usd.empty?
      DeliveryFromCounterparty.create(
        user_id: User.first.id, status: 1,
        payment_type: 0, total_price: debt_in_usd.to_f,
        total_paid: 0, provider_id: id,
        price_in_usd: true
      )
    end

    unless debt_in_uzs.empty?
      DeliveryFromCounterparty.create(
        user_id: User.first.id, status: 1,
        payment_type: 0, total_price: debt_in_uzs.to_f,
        total_paid: 0, provider_id: id,
        price_in_usd: false
      )
    end
  end
end
