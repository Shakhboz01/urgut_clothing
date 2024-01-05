class PagesControllerPolicy < ApplicationPolicy
  def access?
    %w[админ бухгалтер].include?(user.role)
  end
end
