# frozen_string_literal: true

class BrassesController < ApplicationController
  include DiscardController

  before_action :set_index, only: [:index]
  before_action :set_brass, only: [:show, :edit, :update, :discard, :restore, :delete, :destroy]
  before_action :set_associations, only: [:new, :create, :edit, :update]

  # GET /brasses
  # GET /brasses.json
  def index
  end

  # GET /brasses/1
  # GET /brasses/1.json
  def show
    authorize @brass
  end

  # GET /brasses/new
  def new
    @brass = Brass.new
    @brass.user = current_user
    authorize @brass
  end

  # GET /brasses/1/edit
  def edit
    authorize @brass
  end

  # POST /brasses
  # POST /brasses.json
  def create
    @brass = Brass.new(brass_params)
    @brass.user = current_user
    authorize @brass

    respond_to do |format|
      if @brass.save
        format.html { redirect_to @brass, notice: "Brass was successfully created." }
        format.json { render :show, status: :created, location: @brass }
      else
        format.html { render :new }
        format.json { render json: @brass.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /brasses/1
  # PATCH/PUT /brasses/1.json
  def update
    authorize @brass
    respond_to do |format|
      if @brass.update(brass_params)
        format.html { redirect_to @brass, notice: "Brass was successfully updated." }
        format.json { render :show, status: :ok, location: @brass }
      else
        format.html { render :edit }
        format.json { render json: @brass.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /brasses/1
  # DELETE /brasses/1.json
  def destroy
    authorize @brass
    @brass.destroy
    respond_to do |format|
      format.html { redirect_to brasses_url, notice: "Brass was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_associations
      @calibers = policy_scope(Caliber).kept
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_brass
      @brass = policy_scope(Brass).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def brass_params
      params.require(:brass).permit(:name, :caliber_id)
    end
end
