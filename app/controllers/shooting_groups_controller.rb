# frozen_string_literal: true

class ShootingGroupsController < ApplicationController
  include DiscardController

  before_action :set_index, only: [:index]
  before_action :set_shooting_group, only: [:show, :edit, :update, :discard, :restore, :delete, :destroy, :clone]
  before_action :set_associations, only: [:new, :create, :edit, :update, :clone]
  after_action :verify_authorized, except: [:index, :autocomplete, :next_number]
  after_action :verify_policy_scoped, only: [:index, :next_number]

  # GET /shooting_groups
  # GET /shooting_groups.json
  def index
  end

  # GET /shooting_groups/1
  # GET /shooting_groups/1.json
  def show
    authorize @shooting_group
  end

  # GET /shooting_groups/new
  def new
    @shooting_group = ShootingGroup.new(shooting_group_new_params)
    @shooting_group.user = current_user
    authorize @shooting_group
  end

  # GET /shooting_groups/1/edit
  def edit
    authorize @shooting_group
  end

  # POST /shooting_groups
  # POST /shooting_groups.json
  def create
    @shooting_group = ShootingGroup.new(shooting_group_params)
    @shooting_group.user = current_user
    authorize @shooting_group

    respond_to do |format|
      if @shooting_group.save
        format.html { redirect_to @shooting_group, notice: "Shooting group was successfully created." }
        format.json { render :show, status: :created, location: @shooting_group }
      else
        format.html { render :new }
        format.json { render json: @shooting_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shooting_groups/1
  # PATCH/PUT /shooting_groups/1.json
  def update
    authorize @shooting_group
    respond_to do |format|
      if @shooting_group.update(shooting_group_params)
        format.html { redirect_to @shooting_group, notice: "Shooting group was successfully updated." }
        format.json { render :show, status: :ok, location: @shooting_group }
      else
        format.html { render :edit }
        format.json { render json: @shooting_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shooting_groups/1
  # DELETE /shooting_groups/1.json
  def destroy
    authorize @shooting_group
    @shooting_group.destroy
    respond_to do |format|
      format.html { redirect_to shooting_groups_url, notice: "Shooting group was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # GET /shooting_groups/next_number.json
  def next_number
    scope = policy_scope(ShootingGroup).all
    next_number = ShootingGroup.next_number(scope, params[:shooting_log_id], params[:load_id], params[:distance])
    render json: { next_number: next_number }
  end

  # GET /shooting_groups/1/clone
  def clone
    @shooting_group = @shooting_group.clone_record
    authorize @shooting_group
    render :new
  end

  private
    def set_index(joins = :shooting_log)
      super(joins)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_shooting_group
      @shooting_group = policy_scope(ShootingGroup).find(params[:id])
    end

    def set_associations
      @shooting_logs = policy_scope(ShootingLog).kept
      @loads = policy_scope(Load).kept
      @calibers = policy_scope(Caliber).kept
    end

    def shooting_group_new_params
      params.permit(:shooting_log_id, :load_id, :caliber_id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def shooting_group_params
      params.require(:shooting_group).permit(:shooting_log_id, :load_id, :number,
                                             :distance, :distance_unit, :shots, :caliber_id,
                                             :elevation_adjustment, :elevation_adjustment_direction, :elevation_adjustment_unit,
                                             :windage_adjustment, :windage_adjustment_direction, :windage_adjustment_unit,
                                             :wind_speed, :wind_speed_unit, :wind_direction,
                                             :group_size, :group_size_unit)
    end

    def sortable_columns
      ["shooting_logs.date"]
    end

    def default_sort_column
      "shooting_logs.date"
    end

    def default_sort_direction
      "desc"
    end
end
