# agar tovar prixod shavat i tovara xudamo burordagi boshem, prochiye rasxodi + uxod detalo mishud, badaz tovar prixod shudan, user haminoya medarorat
class CombinationOfLocalProduct < ApplicationRecord
  has_many :expenditures, dependent: :destroy
  has_many :product_sells, dependent: :destroy
  has_one :product_entry, dependent: :destroy
  validates_presence_of :status
  enum status: %i[processing closed]
  before_save :proccess_status_change

  def calculate_total_price
    total_price = 0
    self.product_sells.each do |product_sell|
      total_price += product_sell.amount * product_sell.buy_price
    end

    expenditures = self.expenditures.sum(:price)
    total_price += expenditures
    return "" if [total_price, product_entry].any?(&:nil?)

    per_price = total_price.to_f / product_entry.amount
    product_entry.update(buy_price: per_price) unless closed?
    total_price
  end

  private

  def proccess_status_change
    if closed? && status_before_last_save != "closed"
      calculate_total_price
    end
  end
end
