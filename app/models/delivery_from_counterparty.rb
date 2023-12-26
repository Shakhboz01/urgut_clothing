class DeliveryFromCounterparty < ApplicationRecord
  include HandleTransactionHistory
  belongs_to :provider
  belongs_to :user
  has_many :expenditures
  has_many :product_entries, dependent: :destroy
  has_many :transaction_histories, dependent: :destroy
  enum status: %i[processing closed]
  enum payment_type: %i[наличные карта click дригие]
  scope :unpaid, -> { where("total_price > total_paid") }
  scope :price_in_uzs, -> { where('price_in_usd = ?', false) }
  scope :price_in_usd, -> { where('price_in_usd = ?', true) }
  scope :filter_by_total_paid_less_than_price, ->(value) {
          if value == "1"
            where("total_paid < total_price")
          else
            all
          end
        }
  after_save :process_status_change, if: :saved_change_to_status?

  def calculate_total_price(enable_to_alter = true)
    total_price = 0
    self.product_entries.each do |product_entry|
      total_price += product_entry.amount * product_entry.buy_price
    end

    if enable_to_alter
      self.total_price = total_price unless closed?
      self.total_paid = total_price unless closed?
    end

    total_price
  end

  def calculate_sell_price
    sell_price = 0
    self.product_entries.each do |product_entry|
      sell_price += product_entry.amount * product_entry.sell_price
    end

    sell_price
  end

  private

  def process_status_change
    if closed? && status_before_last_save != 'closed'
      price_sign = price_in_usd ? '$' : 'сум'
      message =  "#{user.name.upcase} оформил приход товара от контрагента" \
        "<b>Контрагент</b>: #{provider.name}\n" \
        "<b>Тип оплаты</b>: #{payment_type}\n" \
        "<b>Итого цена прихода:</b> #{total_price} #{price_sign}\n" \
        "<b>Итого цена продажи:</b> #{calculate_sell_price} #{price_sign}\n" \
        "<b>предполагаемый доход:</b> #{calculate_sell_price - total_price} #{price_sign}\n"
      message << "&#9888<b>Оплачено:</b> #{total_paid} #{price_sign}\n" if total_price > total_paid
      message << "<b>Комментарие:</b> #{comment}\n" if comment.present?
      message << "Нажмите <a href=\"#{ENV.fetch('HOST_URL')}/delivery_from_counterparties/#{self.id}\">здесь</a> для просмотра"
      SendMessage.run(message: message)
    end
  end
end
