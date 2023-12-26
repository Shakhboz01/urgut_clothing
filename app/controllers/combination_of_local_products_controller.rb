class CombinationOfLocalProductsController < ApplicationController
  before_action :set_combination_of_local_product, only: %i[ show edit update destroy ]

  # GET /combination_of_local_products or /combination_of_local_products.json
  def index
    @q = CombinationOfLocalProduct.ransack(params[:q])
    @combination_of_local_products = @q.result.order(id: :desc).page(params[:page]).per(40)
  end

  # GET /combination_of_local_products/1 or /combination_of_local_products/1.json
  def show
    @expenditures = @combination_of_local_product.expenditures
    @expenditures_data = @combination_of_local_product.expenditures
    @product_sells = @combination_of_local_product.product_sells
  end

  # GET /combination_of_local_products/new
  def new
    @combination_of_local_product = CombinationOfLocalProduct.new
  end

  # GET /combination_of_local_products/1/edit
  def edit
  end

  # POST /combination_of_local_products or /combination_of_local_products.json
  def create
    @combination_of_local_product = CombinationOfLocalProduct.new(combination_of_local_product_params)
    respond_to do |format|
      if @combination_of_local_product.save
        format.html { redirect_to combination_of_local_product_url(@combination_of_local_product), notice: "Combination of local product was successfully created." }
        format.json { render :show, status: :created, location: @combination_of_local_product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @combination_of_local_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /combination_of_local_products/1 or /combination_of_local_products/1.json
  def update
    respond_to do |format|
      if @combination_of_local_product.update(
        combination_of_local_product_params.merge(status: combination_of_local_product_params[:status].to_i)
      )
        if @combination_of_local_product.closed?
          format.html { redirect_to edit_product_entry_url(@combination_of_local_product.product_entry), notice: "Укажите цену продажи" }
        else
          format.html { redirect_to combination_of_local_products_url, notice: "Combination of local product was successfully updated." }
        end

        format.json { render :show, status: :ok, location: @combination_of_local_product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @combination_of_local_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /combination_of_local_products/1 or /combination_of_local_products/1.json
  def destroy
    @combination_of_local_product.destroy

    respond_to do |format|
      format.html { redirect_to combination_of_local_products_url, notice: "Combination of local product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_combination_of_local_product
    @combination_of_local_product = CombinationOfLocalProduct.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def combination_of_local_product_params
    params.require(:combination_of_local_product).permit(:comment, :status)
  end
end
