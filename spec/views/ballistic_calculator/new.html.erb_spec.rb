# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ballistic_calculator/new", type: :view do
  before(:each) do
    assign(:calibers, create_list(:caliber, 2))
    assign(:ballistic_calculator, BallisticCalculator.new)
  end

  it "renders new ballistic_calculator form" do
    render

    assert_select "form[action=?][method=?]", ballistic_calculator_path, "post" do
      assert_select "select[name=?]", "ballistic_calculator[caliber_id]"
      assert_select "select[name=?]", "ballistic_calculator[load_id]"
      assert_select "select[name=?]", "ballistic_calculator[gun_id]"
      assert_select "input[name=?]", "ballistic_calculator[ballistic_coefficient]"
      assert_select "input[name=?]", "ballistic_calculator[velocity]"
      assert_select "input[name=?]", "ballistic_calculator[height_of_sight]"
      assert_select "input[name=?]", "ballistic_calculator[zero_range]"
      assert_select "select[name=?]", "ballistic_calculator[scope_moa_adjustment]"
      assert_select "input[name=?]", "ballistic_calculator[wind_speed]"
    end
  end
end
