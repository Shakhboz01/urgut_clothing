class LocalService < ApplicationRecord
  belongs_to :sale_from_local_service
  belongs_to :user, optional: true
  validates :price, comparison: { greater_than: 0 }
  validates_presence_of :price
  after_create :increase_total_price
  before_destroy :verify_sale_is_not_closed
  before_destroy :decrease_total_price

  private

  def increase_total_price
    sale_from_local_service.increment!(:total_price, price)
    sale_from_local_service.increment!(:total_paid, price)
  end

  def decrease_total_price
    sale_from_local_service.decrement!(:total_paid, price)
    sale_from_local_service.decrement!(:total_price, price)
  end

  def verify_sale_is_not_closed
    return errors.add(:base, "canot be destroyed") if sale_from_local_service.closed?
  end
end
