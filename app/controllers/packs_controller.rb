class PacksController < ApplicationController
  before_action :set_pack, only: %i[ show edit update destroy ]

  # GET /packs or /packs.json
  def index
    @packs = Pack.all
  end

  # GET /packs/1 or /packs/1.json
  def show
  end

  # GET /packs/new
  def new
    @pack = Pack.new
  end

  # GET /packs/1/edit
  def edit
  end

  # POST /packs or /packs.json
  def create
    @pack = Pack.new(pack_params)

    respond_to do |format|
      if @pack.save
        format.html { redirect_to pack_url(@pack), notice: "Pack was successfully created." }
        format.json { render :show, status: :created, location: @pack }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @pack.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /packs/1 or /packs/1.json
  def update
    respond_to do |format|
      if @pack.update(pack_params)
        format.html { redirect_to pack_url(@pack), notice: "Pack was successfully updated." }
        format.json { render :show, status: :ok, location: @pack }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pack.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /packs/1 or /packs/1.json
  def destroy
    @pack.destroy

    respond_to do |format|
      format.html { redirect_to packs_url, notice: "Pack was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pack
      @pack = Pack.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pack_params
      params.require(:pack).permit(:name, product_size_colors_attributes: [:size, :color_id, :amount])
    end
end
