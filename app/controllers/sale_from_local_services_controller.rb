class SaleFromLocalServicesController < ApplicationController
  before_action :set_sale_from_local_service, only: %i[ show edit update destroy ]

  # GET /sale_from_local_services or /sale_from_local_services.json
  def index
    @q = SaleFromLocalService.ransack(params[:q])
    @sale_from_local_services =
      @q.result.filter_by_total_paid_less_than_price(params.dig(:q_other, :total_paid_less_than_price))
        .order(id: :desc)

    @all_sale_from_local_services = @sale_from_local_services
    @sale_from_local_services = @sale_from_local_services.page(params[:page]).per(40)
  end

  # GET /sale_from_local_services/1 or /sale_from_local_services/1.json
  def show
    @product_sells = @sale_from_local_service.product_sells
    @local_services = @sale_from_local_service.local_services
  end

  # GET /sale_from_local_services/new
  def new
    @sale_from_local_service = SaleFromLocalService.new
  end

  # GET /sale_from_local_services/1/edit
  def edit
  end

  # POST /sale_from_local_services or /sale_from_local_services.json
  def create
    @sale_from_local_service = SaleFromLocalService.new(sale_from_local_service_params)
    @sale_from_local_service.user_id = current_user.id
    respond_to do |format|
      if @sale_from_local_service.save
        format.html { redirect_to sale_from_local_service_url(@sale_from_local_service), notice: "Sale from local service was successfully created." }
        format.json { render :show, status: :created, location: @sale_from_local_service }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sale_from_local_service.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sale_from_local_services/1 or /sale_from_local_services/1.json
  def update
    respond_to do |format|
      if @sale_from_local_service.update(sale_from_local_service_params.merge(status: sale_from_local_service_params[:status].to_i))
        format.html { redirect_to sale_from_local_services_url, notice: "Sale from local service was successfully updated." }
        format.json { render :show, status: :ok, location: @sale_from_local_service }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sale_from_local_service.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sale_from_local_services/1 or /sale_from_local_services/1.json
  def destroy
    @sale_from_local_service.destroy

    respond_to do |format|
      format.html { redirect_to sale_from_local_services_url, notice: "Sale from local service was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def default_create
    buyer = Buyer.first
    sfs = SaleFromLocalService.new(buyer: buyer, user: current_user)
    if sfs.save
      redirect_to sale_from_local_service_url(sfs), notice: "Теперь добавьте услуги и рассход товаров"
    else
      redirect_to request.referrer, notice: "Something went wrong"
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_sale_from_local_service
    @sale_from_local_service = SaleFromLocalService.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def sale_from_local_service_params
    params.require(:sale_from_local_service).permit(:total_price, :total_paid, :coment, :buyer_id, :payment_type, :status, :total_expenditure, :user_id)
  end
end
