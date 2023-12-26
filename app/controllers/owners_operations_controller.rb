class OwnersOperationsController < ApplicationController
  before_action :set_owners_operation, only: %i[ show edit update destroy ]

  # GET /owners_operations or /owners_operations.json
  def index
    @owners = User.руководитель.pluck(:name, :id)
    @q = OwnersOperation.ransack(params[:q])
    @owners_operations = @q.result.order(id: :desc)
    @all_owners_operations = @owners_operations
    @owners_operations = @owners_operations.page(params[:page]).per(40)

  end

  # GET /owners_operations/1 or /owners_operations/1.json
  def show
  end

  # GET /owners_operations/new
  def new
    @owners_operation = OwnersOperation.new
  end

  # GET /owners_operations/1/edit
  def edit
  end

  # POST /owners_operations or /owners_operations.json
  def create
    @owners_operation = OwnersOperation.new(owners_operation_params)
    @owners_operation.operator = current_user

    respond_to do |format|
      if @owners_operation.save
        format.html { redirect_to owners_operations_url, notice: "Owners operation was successfully created." }
        format.json { render :show, status: :created, location: @owners_operation }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @owners_operation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /owners_operations/1 or /owners_operations/1.json
  def update
    respond_to do |format|
      if @owners_operation.update(owners_operation_params)
        format.html { redirect_to owners_operations_url, notice: "Owners operation was successfully updated." }
        format.json { render :show, status: :ok, location: @owners_operation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @owners_operation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /owners_operations/1 or /owners_operations/1.json
  def destroy
    @owners_operation.destroy

    respond_to do |format|
      format.html { redirect_to owners_operations_url, notice: "Owners operation was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_owners_operation
      @owners_operation = OwnersOperation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def owners_operation_params
      params.require(:owners_operation).permit(:user_id, :outcome, :operation_type, :price_in_usd, :price)
    end
end
