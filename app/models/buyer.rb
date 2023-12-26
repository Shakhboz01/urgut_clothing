class Buyer < ApplicationRecord
  include ProtectDestroyable
  validates_presence_of :name
  validates_uniqueness_of :name
  has_many :sales
  has_many :sale_from_local_services
  has_many :sale_from_services
  scope :active, -> { where(:active => true) }

  def calculate_debt_in_usd
    self.sales.unpaid.price_in_usd.sum(:total_price) - self.sales.unpaid.price_in_usd.sum(:total_paid)
  end

  def calculate_debt_in_uzs
    self.sales.unpaid.price_in_uzs.sum(:total_price) - self.sales.unpaid.price_in_uzs.sum(:total_paid)
  end
end
