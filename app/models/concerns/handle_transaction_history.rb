module HandleTransactionHistory
  extend ActiveSupport::Concern

  included do
    before_update :create_th
    before_destroy :protect_destroy
  end

  private

  def create_th
    if closed? && status_before_last_save != "closed"
      self.transaction_histories.create(price: total_paid, price_in_usd: price_in_usd, user_id: user_id, first_record: true)
    end
  end

  def protect_destroy
    return errors.add(:base, "cannot be destroyed")
    throw(:abort)
  end
end
