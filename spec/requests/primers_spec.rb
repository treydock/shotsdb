# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Primers", type: :request do
  describe "GET /primers" do
    it "works! (now write some real specs)" do
      sign_in create(:user)
      get primers_path
      expect(response).to have_http_status(200)
    end
  end
end
