class UserPolicy < ApplicationPolicy
  def access?
    user_is_manager?
  end

  def manage?
    user_is_manager?
  end
end
