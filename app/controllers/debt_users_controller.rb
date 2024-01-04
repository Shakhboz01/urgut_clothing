class DebtUsersController < ApplicationController
  before_action :set_debt_user, only: %i[ show edit update destroy ]

  # GET /debt_users or /debt_users.json
  def index
    @debt_users = DebtUser.all
  end

  # GET /debt_users/1 or /debt_users/1.json
  def show
  end

  # GET /debt_users/new
  def new
    @debt_user = DebtUser.new
  end

  # GET /debt_users/1/edit
  def edit
  end

  # POST /debt_users or /debt_users.json
  def create
    @debt_user = DebtUser.new(debt_user_params)

    respond_to do |format|
      if @debt_user.save
        format.html { redirect_to debt_operations_url, notice: "Debt user was successfully created." }
        format.json { render :show, status: :created, location: @debt_user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @debt_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /debt_users/1 or /debt_users/1.json
  def update
    respond_to do |format|
      if @debt_user.update(debt_user_params)
        format.html { redirect_to debt_operations_url, notice: "Debt user was successfully updated." }
        format.json { render :show, status: :ok, location: @debt_user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @debt_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /debt_users/1 or /debt_users/1.json
  def destroy
    @debt_user.destroy

    respond_to do |format|
      format.html { redirect_to debt_users_url, notice: "Debt user was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_debt_user
      @debt_user = DebtUser.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def debt_user_params
      params.require(:debt_user).permit(:name)
    end
end
