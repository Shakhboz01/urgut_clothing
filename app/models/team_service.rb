class TeamService < ApplicationRecord
  belongs_to :sale_from_service
  belongs_to :team
  belongs_to :user
  validates :team_fee, comparison: { greater_than_or_equal_to: 0 }
  validates :total_price, comparison: { greater_than: 0 }
  before_create :validate_sale_is_not_closed
  after_create :increase_total_price
  before_save :set_portions
  before_save :validate_sale_is_not_closed
  before_destroy :validate_sale_is_not_closed
  before_destroy :decrease_total_price

  private

  def increase_total_price
    sale_from_service.increment!(:total_price, total_price)
  end

  def decrease_total_price
    sale_from_service.decrement!(:total_price, total_price)
  end

  def validate_sale_is_not_closed
    return throw(:abort) if sale_from_service.closed?
  end

  def set_portions
    self.team_portion = total_price * (total_price.to_f / 100)
    self.company_portion = total_price - team_portion
  end
end
