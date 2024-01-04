class DailyTransactionReportPolicy < ApplicationPolicy
  def access?
    user_is_manager?
  end

  def manage?
    %w[кассир].include?(user.role)
  end
end
