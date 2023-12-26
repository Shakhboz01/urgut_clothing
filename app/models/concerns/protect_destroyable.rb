module ProtectDestroyable
  extend ActiveSupport::Concern

  included do
    before_destroy :protect_destroy
  end

  private

  def protect_destroy
    return errors.add(:base, "cannot be destroyed")
    throw(:abort)
  end
end
