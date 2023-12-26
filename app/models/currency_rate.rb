class CurrencyRate < ApplicationRecord
  include ProtectDestroyable

  validates_presence_of :rate

  before_create :set_finished_at

  private

  def set_finished_at
    CurrencyRate.where(finished_at: nil).last&.update(finished_at: DateTime.current)
  end
end
