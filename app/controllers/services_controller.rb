class ServicesController < ApplicationController
  before_action :set_service, only: %i[ show edit update destroy toggle_active ]

  # GET /services or /services.json
  def index
    @q = Service.ransack(params[:q])
    @services = @q.result.order(active: :desc).page(params[:page]).per(40)
  end

  # GET /services/1 or /services/1.json
  def show
  end

  # GET /services/new
  def new
    @service = Service.new
  end

  # GET /services/1/edit
  def edit
  end

  # POST /services or /services.json
  def create
    @service = Service.new(service_params.merge(user_id: current_user.id))

    respond_to do |format|
      if @service.save
        format.turbo_stream do
          render turbo_stream: turbo_stream.prepend(
            "new_service", partial: "services/new_service", locals: { service: @service },
          )
        end
        format.html { redirect_to services_url, notice: "Service was successfully created." }
        format.json { render :show, status: :created, location: @service }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /services/1 or /services/1.json
  def update
    respond_to do |format|
      if @service.update(service_params.merge(user_id: current_user.id))
        format.html { redirect_to services_url, notice: "Service was successfully updated." }
        format.json { render :show, status: :ok, location: @service }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /services/1 or /services/1.json
  def destroy
    @service.destroy

    respond_to do |format|
      format.html { redirect_to services_url, notice: "Service was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def toggle_active
    @service.toggle(:active).save
    redirect_to services_url, notice: "Successfully updated"
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_service
    @service = Service.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def service_params
    params.require(:service).permit(:name, :unit, :service_price, :active, :user_id, :price, :team_fee_in_percent)
  end
end
