class PrimersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_primer, only: [:show, :edit, :update, :destroy]

  # GET /primers
  # GET /primers.json
  def index
    @primers = Primer.by_user(current_user).all
  end

  # GET /primers/1
  # GET /primers/1.json
  def show
  end

  # GET /primers/new
  def new
    @primer = Primer.new
  end

  # GET /primers/1/edit
  def edit
  end

  # POST /primers
  # POST /primers.json
  def create
    @primer = Primer.new(primer_params)
    @primer.user = current_user

    respond_to do |format|
      if @primer.save
        format.html { redirect_to @primer, notice: 'Primer was successfully created.' }
        format.json { render :show, status: :created, location: @primer }
      else
        format.html { render :new }
        format.json { render json: @primer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /primers/1
  # PATCH/PUT /primers/1.json
  def update
    respond_to do |format|
      if @primer.update(primer_params)
        format.html { redirect_to @primer, notice: 'Primer was successfully updated.' }
        format.json { render :show, status: :ok, location: @primer }
      else
        format.html { render :edit }
        format.json { render json: @primer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /primers/1
  # DELETE /primers/1.json
  def destroy
    @primer.destroy
    respond_to do |format|
      format.html { redirect_to primers_url, notice: 'Primer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_primer
      @primer = Primer.by_user(current_user).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def primer_params
      params.require(:primer).permit(:name)
    end
end