class SalariesController < ApplicationController
  before_action :set_salary, only: %i[ show edit update destroy ]

  # GET /salaries or /salaries.json
  def index
    @q = Salary.ransack(params[:q])
    @salaries = @q.result.order(created_at: :desc)
    # info
    @total_by_prepayment = @salaries.where(prepayment: true).count
    @total_by_payment = @salaries.count - @total_by_prepayment
    @total_price = @salaries.sum(:price)
    @salaries = @salaries.page(params[:page]).per(40)
  end

  # GET /salaries/1 or /salaries/1.json
  def show
  end

  # GET /salaries/new
  def new
    @salary = Salary.new(
      team_id: params[:team_id],
      user_id: params[:user_id],
    )
    @hidden = @salary.team_id.present? || @salary.user_id.present?
  end

  # GET /salaries/1/edit
  def edit
  end

  # POST /salaries or /salaries.json
  def create
    @salary = Salary.new(salary_params)

    respond_to do |format|
      if @salary.save
        format.html { redirect_to salaries_url, notice: "Salary was successfully created." }
        format.json { render :show, status: :created, location: @salary }
      else
        format.html { render :new, salary: @salary, status: :unprocessable_entity }
        format.json { render json: @salary.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /salaries/1 or /salaries/1.json
  def update
    respond_to do |format|
      if @salary.update(salary_params)
        format.html { redirect_to salaries_url, notice: "Salary was successfully updated." }
        format.json { render :show, status: :ok, location: @salary }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @salary.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /salaries/1 or /salaries/1.json
  def destroy
    @salary.destroy

    respond_to do |format|
      format.html { redirect_to salaries_url, notice: "Salary was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_salary
    @salary = Salary.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def salary_params
    params.require(:salary).permit(:prepayment, :month, :team_id, :user_id, :price_in_usd, :price_in_uzs, :payment_type, :price)
  end
end
