# @author nirina
require 'swagger_helper'

# API V1 AuthController Requests Test Spec
# Generate Swagger json doc
# @see https://github.com/drewish/rspec-rails-swagger
RSpec.describe 'API::V1::Auth', type: :request, capture_examples: true do
  # Auth login path resource path
  path '/api/auth/login' do
    # required body parameter Schema
    parameter :credentials, in: :body, required: true, schema: {
      type: :object,
      properties: {
        username: { type: :string },
        password: { type: :string }
      }
    }

    # POST /api/auth/login request
    post(summary: 'authenticate a user') do
      consumes 'application/json'
      produces 'application/json'

      # Expect a success response when credentials are valid
      response(200, description: 'success authentication') do
        # create an active user
        let!(:active_user) { FactoryBot.create(:user, active: true) }
        # define :credentials params by passing valid :active_user username and password 
        let(:credentials) do
          {
            username: active_user.username, password: active_user.password
          }
        end

        # Expect response to include auth token
        it 'returns an authentication token' do
          expect(json['auth_token']).not_to be_nil
        end
      end

      # Expect an unauthorized response when the user is not active
      response(401, description: 'unauthorized user') do
        # create a non active user
        let!(:nonactive_user) { FactoryBot.create(:user, username: 'erick') }
        # passing non active user username and password to :credentials params
        let(:credentials) do
          {
            username: nonactive_user.username, password: nonactive_user.password
          }
        end

        # Expect response to include Account not active message
        it 'returns a non active account message' do
          expect(json['message']).to match(/Account not active/)
        end
      end

      # Expect a bad request response when credentials are not valid
      response(400, description: 'bad request') do
        # create an invalid credentials
        let(:credentials) do
          {
            username: 'nonexistantusername', password: 'nonexistantpassword'
          }
        end

        # Expect response to include Invalid credentials message
        it 'returns an invalid credentials message' do
          expect(json['message']).to match(/Invalid credentials/)
        end
      end
    end
  end
end
