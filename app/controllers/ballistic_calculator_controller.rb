# frozen_string_literal: true

class BallisticCalculatorController < ApplicationController
  before_action :set_associations

  respond_to :html, :js

  # GET /ballistic_calculator
  def new
    @ballistic_calculator = BallisticCalculator.new
    authorize @ballistic_calculator
  end

  # POST /ballistic_calculator
  # POST /ballistic_calculator.js
  def create
    @ballistic_calculator = BallisticCalculator.new(ballistic_calculator_params)
    authorize @ballistic_calculator
    @ranges = BallisticCalculator.ranges(@ballistic_calculator.ranges_max, @ballistic_calculator.ranges_interval)

    respond_to do |format|
      if @ballistic_calculator.valid?
        format.js
        format.html { render :show }
      else
        format.js { render :new }
        format.html { render :show }
      end
    end
  end

  private
    def set_associations
      @calibers = policy_scope(Caliber).all
      @loads = policy_scope(Load).all
      @guns = policy_scope(Gun).all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ballistic_calculator_params
      params.require(:ballistic_calculator).permit(:caliber_id, :load_id, :gun_id,
                                                   :ballistic_coefficient, :velocity,
                                                   :height_of_sight, :zero_range,
                                                   :ranges_max, :ranges_interval,
                                                   :scope_moa_adjustment, :wind_speed)
    end
end
