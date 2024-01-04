class DebtOperation < ApplicationRecord
  belongs_to :user
  belongs_to :debt_user
  vailidates_presence_of :price
  enum status: %i[приём отдача]
  scope :price_in_uzs, -> { where('price_in_usd = ?', false) }
  scope :price_in_usd, -> { where('price_in_usd = ?', true) }
end
