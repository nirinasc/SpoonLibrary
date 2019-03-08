require 'rails_helper'

RSpec.describe "API::V1::Users", type: :request do
  
  let(:user) { FactoryBot.create(:user,active: true)}
  let(:header) { headers(user.id).slice('Authorization') }

  describe "GET /api/me" do
    before { get api_user_me_path, headers: header }

    it "respond with the current user info" do
      expect(json['id']).to eq(user.id)
    end

    it "return a success response code" do
      expect(response).to have_http_status(200)
    end

  end
end
