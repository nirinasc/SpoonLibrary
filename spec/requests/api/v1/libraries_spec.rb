# @author nirina
require 'swagger_helper'

# API V1 LibrariesController Requests Test Spec
# Generate Swagger json doc
# @see https://github.com/drewish/rspec-rails-swagger
RSpec.describe 'API::V1::Libraries', type: :request, capture_examples: true  do
  # libraries resource path
  path '/api/libraries' do
    # Fill in the db with 5 libraries
    before do
      5.times do |index|
        FactoryBot.create(:library, name: "library-#{index}")
      end
    end

    # GET /api/libraries
    # optional query param q (ex: q[name_cont]=library_name)
    # @see https://github.com/activerecord-hackery/ransack
    get(summary: 'libraries list') do
      produces 'application/json'
      parameter 'Authorization', in: :header, type: :string
      # library name filter query param
      parameter 'q[name_cont]', in: :query, type: :string

      # Expect Response with success
      response(200, description: 'successful') do
        let(:user) { FactoryBot.create(:user, active: true) }
        let(:Authorization) { "Bearer #{headers(user.id)['Authorization']}" }

        # When no filter is applied
        context 'When there is no filter' do
          # all libraries must be returned
          it 'return all libraries' do
            expect(json.count).to eq(5)
          end
        end

        # When a name filter is applied
        context 'When a name filter is applied' do
          let(:'q[name_cont]') { 'library-1' }

          # Only libraries which name contains filter value appear
          it 'return the filtered library' do
            expect(json.first['name']).to eq('library-1')
            expect(json.count).to eq(1)
          end
        end
      end
    end
  end
end
