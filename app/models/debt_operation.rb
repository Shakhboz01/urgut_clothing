class DebtOperation < ApplicationRecord
  belongs_to :user
  belongs_to :debt_user
  validates_presence_of :price
  enum status: %i[приём отдача]
  scope :price_in_uzs, -> { where('debt_in_usd = ?', false) }
  scope :price_in_usd, -> { where('debt_in_usd = ?', true) }
end
