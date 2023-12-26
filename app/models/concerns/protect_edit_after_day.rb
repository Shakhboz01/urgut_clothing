module ProtectEditAfterDay
  extend ActiveSupport::Concern

  included do
    before_update :check_permission
  end

  private

  def check_permission
    if created_at < DateTime.current - 1.day
      errors.add(:base, "Cannot edit record after 1 day from creation.")
      throw(:abort)  # This will stop the update from proceeding
    end
  end
end
