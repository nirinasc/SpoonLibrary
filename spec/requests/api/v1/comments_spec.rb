# @author nirina
require 'swagger_helper'

# API V1 CommentsController Requests Test Spec
# Generate Swagger json doc
# @see https://github.com/drewish/rspec-rails-swagger
RSpec.describe 'API::V1::Comments', type: :request do
  # create a library
  let(:library) { FactoryBot.create(:library) }
  # create categories
  let(:categories) do
    categories = []
    3.times { categories << FactoryBot.create(:category) }
    return categories
  end
  # create a book by assigning the library and categories
  let(:book) { FactoryBot.create(:book, library: library, categories: categories) }
  # define the user who issue next requests
  let(:user) { FactoryBot.create(:user, active: true) }

  before do
    # create 10 comments
    10.times do
      FactoryBot.create(:comment, user: user, book: book)
    end
  end

  # book comments resource path
  path '/api/books/{book_id}/comments' do
    # book_id path parameter def
    parameter 'book_id', in: :path, type: :string
    # Authorization header parameter
    parameter 'Authorization', in: :header, type: :string
    # book_id path parameter value
    let(:book_id) { book.id }
    let(:Authorization) { "Bearer #{headers(user.id)['Authorization']}" }

    # GET /api/books/{book_id}/comments
    # GET book(:book_id) comments list
    get(summary: 'book comments list') do
      produces 'application/json'

      # Produce response with 200 status code
      response(200, description: 'successful') do
        # except response to return all comments
        it 'returns all comments' do
          expect(json.count).to eq(10)
        end
      end
    end

    # POST /api/books/{book_id}/comments
    # Create a new comment for book(:book_id)
    post(summary: 'create comment') do
      consumes 'application/json'
      # required body parameter Schema
      parameter :comment, in: :body, required: true, schema: {
        type: :object,
        properties: {
          content: { type: :string }
        }
      }

      # Produce response with 201 status code if the comment is successfully created
      response(201, description: 'comment created') do
        let(:comment) do
          {
            content: 'A really cool book'
          }
        end
      end

      # Produce response with 422 status code if the comment is not valid
      response(422, description: 'content empty or too short') do
        let(:comment) do
          {
            content: 'A'
          }
        end
      end
    end
  end
end
