class LocalServicesController < ApplicationController
  before_action :set_local_service, only: %i[ show edit update destroy ]

  # GET /local_services or /local_services.json
  def index
    @q = LocalService.ransack(params[:q])
    @local_services = @q.result.includes(:user).page(params[:page]).per(40)
  end

  # GET /local_services/1 or /local_services/1.json
  def show
  end

  # GET /local_services/new
  def new
    @local_service = LocalService.new
  end

  # GET /local_services/1/edit
  def edit
  end

  # POST /local_services or /local_services.json
  def create
    @local_service = LocalService.new(local_service_params)

    respond_to do |format|
      if @local_service.save
        format.html { redirect_to sale_from_local_service_url(@local_service.sale_from_local_service), notice: "Local service was successfully created." }
        format.json { render :show, status: :created, location: @local_service }
      else
        format.html { redirect_to request.referrer, notice: @local_service.errors.messages, status: :unprocessable_entity }
        format.json { render json: @local_service.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /local_services/1 or /local_services/1.json
  def update
    respond_to do |format|
      if @local_service.update(local_service_params)
        format.html { redirect_to local_service_url(@local_service), notice: "Local service was successfully updated." }
        format.json { render :show, status: :ok, location: @local_service }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @local_service.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /local_services/1 or /local_services/1.json
  def destroy
    @local_service.destroy

    respond_to do |format|
      format.html { redirect_to sale_from_local_service_url(@local_service.sale_from_local_service), notice: "Local service was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_local_service
    @local_service = LocalService.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def local_service_params
    params.require(:local_service).permit(:price, :comment, :sale_from_local_service_id, :user_id)
  end
end
