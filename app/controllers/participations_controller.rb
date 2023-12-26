class ParticipationsController < ApplicationController
  include Pundit::Authorization

  def index
    authorize Participation, :manage?

    month_year = params.dig(:filter, :month_number)&.first(7)
    if !month_year.nil? && !month_year&.empty?
      first_day_of_selected_month = (month_year + "-01").to_date.beginning_of_month.beginning_of_day
      last_day_of_selected_month = (month_year + "-01").to_date.end_of_month.end_of_day
      @year_number = month_year.split('-').first
      @month_number = month_year.split('-')[1]
    else
      first_day_of_selected_month = Date.current.beginning_of_month.beginning_of_day
      last_day_of_selected_month = Date.current.end_of_month.end_of_day
      @month_number = Date.current.month
      @year_number = Date.current.year
    end

    @participations =
      Participation.where(created_at: first_day_of_selected_month..last_day_of_selected_month)
    @unique_users = @participations.select(:user_id).distinct.map(&:user_id)


    @allowed_for_new_participation = Participation.allowed.empty?
    @month_name = first_day_of_selected_month.strftime('%Y-%m-%d')
    @days = @participations.order(created_at: :desc).pluck('DATE(created_at)').uniq
  end

  def new
    authorize Participation, :manage?

    @users = User.where(active: true)
  end

  def create
    authorize Participation, :manage?
  end

  def accept_new_participation
    authorize Participation, :manage?

    AcceptTodaysParticipation.run!(
      users_particioation_status: params[:filter].permit!.to_h.to_a,
    )

    redirect_to participations_path
  end
end
