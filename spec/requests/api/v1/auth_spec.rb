require 'rails_helper'

RSpec.describe "API::V1::Auth", type: :request do
  describe 'POST /auth/login' do
    let!(:active_user) { FactoryBot.create(:user, active: true) }
    let!(:nonactive_user) { FactoryBot.create(:user, username: 'erick') }

    # set request.headers to our custon headers
    # before { allow(request).to receive(:headers).and_return(headers) }

    # returns auth token when request is valid
    context 'When request is valid' do
      context 'When the user is active' do
        before { post api_auth_login_path, params: credentials_tojson(active_user.username,active_user.password), headers: headers(active_user.id).except('Authorization') }
        it 'returns an authentication token' do
          expect(json['auth_token']).not_to be_nil
        end
        it 'returns a success response' do
          expect(response).to have_http_status(200)
        end
      end

      context 'When the user is not active' do
        before { post api_auth_login_path, params: credentials_tojson(nonactive_user.username,nonactive_user.password), headers: headers(nonactive_user.id).except('Authorization') }
        it 'returns a non active account message' do
          expect(json['message']).to match(/Account not active/)
        end
        it 'returns an unauthorized response status' do
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end

    # returns failure message when request is invalid
    context 'When request is invalid' do
      before { post api_auth_login_path, params: credentials_tojson('username',Faker::Internet.password), headers: headers }
      it 'returns an invalid credentials message' do
        expect(json['message']).to match(/Invalid credentials/)
      end
      it 'returns an unauthorized response status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
