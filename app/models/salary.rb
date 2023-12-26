class Salary < ApplicationRecord
  include ProtectDestroyable
  include ProtectEditAfterDay
  attr_accessor :rate

  belongs_to :team, optional: true
  belongs_to :user, optional: true
  enum payment_type: %i[наличные карта click дригие]

  validates :price, presence: true
  validates_presence_of :month
  validates_presence_of :team, if: -> { user_id.nil? }
  validates_presence_of :user, if: -> { team.nil? }
  validates_absence_of :user, unless: -> { team.nil? }
  validates_absence_of :team, unless: -> { user.nil? }
  after_create :send_notify

  private

  def send_notify
    payment = prepayment ? 'аванс' : 'Зарплата'
    message =
      "Оформлено #{payment} на #{user.name}\n" \
      "Цена: #{price}"
  end
end
