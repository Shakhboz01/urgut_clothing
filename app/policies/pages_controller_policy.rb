class PagesControllerPolicy < ApplicationPolicy
  def access?
    %w[руководитель бухгалтер].include?(user.role)
  end
end
