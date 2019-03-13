# @author nirina
require 'swagger_helper'

# API V1 UsersController Requests Test Spec
# Generate Swagger json doc
# @see https://github.com/drewish/rspec-rails-swagger
RSpec.describe 'API::V1::Users', type: :request, capture_examples: true  do
  # current user's detail resource path
  path '/api/users/me' do
    # GET /api/users/me request
    get(summary: 'retrieve current user info') do
      produces 'application/json'
      parameter 'Authorization', in: :header, type: :string

      # Expect response with success status code
      response(200, description: 'successful') do
        let(:user) { FactoryBot.create(:user, active: true) }
        let(:Authorization) { "Bearer #{headers(user.id)['Authorization']}" }

        # response must contains id eq to current user id
        it 'contains the current user info' do
          expect(json['id']).to eq(user.id)
        end
      end
    end
  end
end
