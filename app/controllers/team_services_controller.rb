class TeamServicesController < ApplicationController
  before_action :set_team_service, only: %i[ show edit update destroy ]

  # GET /team_services or /team_services.json
  def index
    @q = TeamService.ransack(params[:q])
    @all_team_services = @team_services
    @team_services = @q.result
    @all_team_services = @team_services
    @team_services = @team_services.page(params[:page]).per(40)
  end

  # GET /team_services/1 or /team_services/1.json
  def show
  end

  # GET /team_services/new
  def new
    @team_service = TeamService.new
  end

  # GET /team_services/1/edit
  def edit
  end

  # POST /team_services or /team_services.json
  def create
    @team_service = TeamService.new(team_service_params)
    @team_service.user_id = current_user.id
    respond_to do |format|
      if @team_service.save
        format.html { redirect_to sale_from_service_url(@team_service.sale_from_service), notice: "Team service was successfully created." }
        format.json { render :show, status: :created, location: @team_service }
      else
        format.html { redirect_to request.referrer || sale_from_service_url(@team_service.sale_from_service), notice: "error occured" }
        format.json { render json: @team_service.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /team_services/1 or /team_services/1.json
  def update
    respond_to do |format|
      if @team_service.update(team_service_params)
        format.html { redirect_to team_service_url(@team_service), notice: "Team service was successfully updated." }
        format.json { render :show, status: :ok, location: @team_service }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @team_service.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /team_services/1 or /team_services/1.json
  def destroy
    @team_service.destroy

    respond_to do |format|
      format.html { redirect_to request.referrer || sale_from_service_url(@team_service.sale_from_service), notice: "Successfully destroyed" }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_team_service
    @team_service = TeamService.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def team_service_params
    params.require(:team_service).permit(:sale_from_service_id, :team_id, :total_price, :team_fee, :team_portion, :company_portion, :user_id, :comment)
  end
end
