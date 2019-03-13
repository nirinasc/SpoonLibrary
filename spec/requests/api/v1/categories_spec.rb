# @author nirina
require 'swagger_helper'

# API V1 categoriesController Requests Test Spec
# Generate Swagger json doc
# @see https://github.com/drewish/rspec-rails-swagger
RSpec.describe 'API::V1::Categories', type: :request, capture_examples: true  do
  # categories resource path
  path '/api/categories' do
    # Fill in the db with 5 categories
    before do
      5.times do |index|
        FactoryBot.create(:category, name: "category-#{index}")
      end
    end

    # GET /api/categories
    # optional query param q (ex: q[name_cont]=category_name)
    # @see https://github.com/activerecord-hackery/ransack
    get(summary: 'categories list') do
      produces 'application/json'
      parameter 'Authorization', in: :header, type: :string
      # category name filter query param
      parameter 'q[name_cont]', in: :query, type: :string
      # Expect Response with success

      response(200, description: 'successful') do
        let(:user) { FactoryBot.create(:user, active: true) }
        let(:Authorization) { "Bearer #{headers(user.id)['Authorization']}" }

        # When no filter is applied
        context 'When there is no filter' do
          # all libraries must be returned
          it 'return all categories' do
            expect(json.count).to eq(5)
          end
        end

        # When a name filter is applied
        context 'When a name filter is applied' do
          let(:'q[name_cont]') { 'category-1' }

          # Only categories which name contains filter value appear
          it 'return the filtered category' do
            expect(json.first['name']).to eq('category-1')
            expect(json.count).to eq(1)
          end
        end
      end
    end
  end
end
