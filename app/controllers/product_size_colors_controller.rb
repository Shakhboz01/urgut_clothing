class ProductSizeColorsController < ApplicationController
  before_action :set_product_size_color, only: %i[ show edit update destroy ]

  # GET /product_size_colors or /product_size_colors.json
  def index
    @product_size_colors = ProductSizeColor.all
  end

  # GET /product_size_colors/1 or /product_size_colors/1.json
  def show
  end

  # GET /product_size_colors/new
  def new
    @product_size_color = ProductSizeColor.new
  end

  # GET /product_size_colors/1/edit
  def edit
  end

  # POST /product_size_colors or /product_size_colors.json
  def create
    @product_size_color = ProductSizeColor.new(product_size_color_params)

    respond_to do |format|
      if @product_size_color.save
        format.html { redirect_to product_size_color_url(@product_size_color), notice: "Product size color was successfully created." }
        format.json { render :show, status: :created, location: @product_size_color }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product_size_color.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /product_size_colors/1 or /product_size_colors/1.json
  def update
    respond_to do |format|
      if @product_size_color.update(product_size_color_params)
        format.html { redirect_to product_size_color_url(@product_size_color), notice: "Product size color was successfully updated." }
        format.json { render :show, status: :ok, location: @product_size_color }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product_size_color.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /product_size_colors/1 or /product_size_colors/1.json
  def destroy
    @product_size_color.destroy

    respond_to do |format|
      format.html { redirect_to product_size_colors_url, notice: "Product size color was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product_size_color
      @product_size_color = ProductSizeColor.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_size_color_params
      params.require(:product_size_color).permit(:color_id, :size_id, :amount, :pack_id)
    end
end
