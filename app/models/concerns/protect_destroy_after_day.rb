module ProtectDestroyAfterDay
  extend ActiveSupport::Concern

  included do
    before_destroy :check_permission
  end

  private

  def check_permission
    if created_at < (DateTime.current - 1.day)
      errors.add(:base, "Cannot edit record after 1 day from creation.") and throw(:abort)
    end
  end
end
