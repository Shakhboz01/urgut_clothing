class DebtOperationsController < ApplicationController
  before_action :set_debt_operation, only: %i[ show edit update destroy ]

  # GET /debt_operations or /debt_operations.json
  def index
    @q = DebtOperation.ransack(params[:q])
    @debt_operations = @q.result.order(id: :desc)
    @all_debt_operations = @debt_operations
    @debt_operations = @debt_operations.page(params[:page]).per(40)
  end

  # GET /debt_operations/1 or /debt_operations/1.json
  def show
  end

  # GET /debt_operations/new
  def new
    @debt_operation = DebtOperation.new
  end

  # GET /debt_operations/1/edit
  def edit
  end

  # POST /debt_operations or /debt_operations.json
  def create
    @debt_operation = DebtOperation.new(debt_operation_params)
    @debt_operation.user_id = current_user.id

    respond_to do |format|
      if @debt_operation.save
        format.html { redirect_to debt_operations_url, notice: "Debt operation was successfully created." }
        format.json { render :show, status: :created, location: @debt_operation }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @debt_operation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /debt_operations/1 or /debt_operations/1.json
  def update
    respond_to do |format|
      if @debt_operation.update(debt_operation_params)
        format.html { redirect_to debt_operations_url, notice: "Debt operation was successfully updated." }
        format.json { render :show, status: :ok, location: @debt_operation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @debt_operation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /debt_operations/1 or /debt_operations/1.json
  def destroy
    @debt_operation.destroy

    respond_to do |format|
      format.html { redirect_to debt_operations_url, notice: "Debt operation was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_debt_operation
      @debt_operation = DebtOperation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def debt_operation_params
      params.require(:debt_operation).permit(:debt_in_usd, :status, :price, :user_id, :debt_user_id, :comment)
    end
end
