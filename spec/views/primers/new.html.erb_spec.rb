# frozen_string_literal: true

require "rails_helper"

RSpec.describe "primers/new", type: :view do
  before(:each) do
    assign(:primer, Primer.new(user: create(:user)))
  end

  it "renders new primer form" do
    render

    assert_select "form[action=?][method=?]", primers_path, "post" do
      assert_select "input[name=?]", "primer[name]"
    end
  end
end
