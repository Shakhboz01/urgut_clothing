class ProductRemainingInequalitiesController < ApplicationController
  before_action :set_product_remaining_inequality, only: %i[ show edit update destroy ]

  # GET /product_remaining_inequalities or /product_remaining_inequalities.json
  def index
    @q = ProductRemainingInequality.ransack(params[:q])
    @product_remaining_inequalities = @q.result.order(created_at: :desc).page(params[:page]).per(40)
  end

  # GET /product_remaining_inequalities/1 or /product_remaining_inequalities/1.json
  def show
  end

  # GET /product_remaining_inequalities/new
  def new
    product = Product.find(params[:product_id])
    @product_remaining_inequality = ProductRemainingInequality.new(
      product_id: product.id,
      previous_amount: product.calculate_product_remaining,
    )
  end

  # GET /product_remaining_inequalities/1/edit
  def edit
  end

  # POST /product_remaining_inequalities or /product_remaining_inequalities.json
  def create
    @product_remaining_inequality = ProductRemainingInequality.new(product_remaining_inequality_params)
    @product_remaining_inequality.user = current_user
    respond_to do |format|
      if @product_remaining_inequality.save
        format.html { redirect_to products_url, notice: "Product remaining inequality was successfully created." }
        format.json { render :show, status: :created, location: @product_remaining_inequality }
      else
        format.html { redirect_to request.referrer, notice: @product_remaining_inequality.errors.messages }
        format.json { render json: @product_remaining_inequality.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /product_remaining_inequalities/1 or /product_remaining_inequalities/1.json
  def update
    respond_to do |format|
      if @product_remaining_inequality.update(product_remaining_inequality_params)
        format.html { redirect_to products_url, notice: "Product remaining inequality was successfully updated." }
        format.json { render :show, status: :ok, location: @product_remaining_inequality }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product_remaining_inequality.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /product_remaining_inequalities/1 or /product_remaining_inequalities/1.json
  def destroy
    @product_remaining_inequality.destroy

    respond_to do |format|
      format.html { redirect_to product_remaining_inequalities_url, notice: "Product remaining inequality was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_product_remaining_inequality
    @product_remaining_inequality = ProductRemainingInequality.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def product_remaining_inequality_params
    params.require(:product_remaining_inequality).permit(:product_id, :amount, :previous_amount, :reason, :user_id)
  end
end
