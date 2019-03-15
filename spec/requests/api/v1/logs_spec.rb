# @author nirina
require 'swagger_helper'

# API V1 LogsController Requests Test Spec
# Generate Swagger json doc
# @see https://github.com/drewish/rspec-rails-swagger
RSpec.describe 'api/v1/logs', type: :request do
  # create a library
  let(:library) { FactoryBot.create(:library) }
  # create categories
  let(:categories) do
    categories = []
    3.times { categories << FactoryBot.create(:category) }
    return categories
  end
  # define the user who issue next requests
  let(:user) { FactoryBot.create(:user, active: true) }

  # fill db with books, book loan and book returns before all
  before do
    10.times do |index|
      book = FactoryBot.create(:book, library: library, categories: categories)
      next if index < 5

      book_loan = FactoryBot.create(:book_loan, user: user, book: book, returned: false)
      # create book returns for 3 last loans
      FactoryBot.create(:book_return, user: user, book: book, loan: book_loan) if index > 6
    end
  end

  # book_loan logs resource path
  path '/api/logs/loans' do
    # Authorization header parameter
    parameter 'Authorization', in: :header, type: :string
    # Authorization header value
    let(:Authorization) { "Bearer #{headers(user.id)['Authorization']}" }

    # GET /api/logs/loans request
    # Retrieve current user logs list of type book_loan
    # optional query param q (ex: q[returned_eq]=true)
    # @see https://github.com/activerecord-hackery/ransack
    get(summary: 'book loans list') do
      produces 'application/json'
      # returned status filter query param
      parameter 'q[returned_eq]', in: :query, type: :string

      # Produce response with 200 status code
      response(200, description: 'successful') do
        # all book loans must be returned
        it 'return all book loans' do
          expect(json.count).to eq(5)
        end
      end
    end
  end

  # book_return logs resource path
  path '/api/logs/returns' do
    # Authorization header parameter
    parameter 'Authorization', in: :header, type: :string
    # Authorization header value
    let(:Authorization) { "Bearer #{headers(user.id)['Authorization']}" }

    # GET /api/logs/returns request
    # Retrieve current user logs list of type book_loan
    # optional query param q (ex: q[book_id_eq]=5)
    # @see https://github.com/activerecord-hackery/ransack
    get(summary: 'book returns list') do
      produces 'application/json'
      # book_id filter query param
      parameter 'q[book_id_eq]', in: :query, type: :string
      # loan_id filter query param
      parameter 'q[loan_id_eq]', in: :query, type: :string

      # Produce response with 200 status code
      response(200, description: 'successful') do
        # all book returns must be returned
        it 'return all book returns' do
          expect(json.count).to eq(3)
        end
      end
    end
  end

  # book_return logs create resource path
  path '/api/logs/{loan_id}/returns' do
    # loan_id path paramater def
    parameter 'loan_id', in: :path, type: :string
    # Authorization header parameter
    parameter 'Authorization', in: :header, type: :string
    # Authorization header value
    let(:Authorization) { "Bearer #{headers(user.id)['Authorization']}" }

    # POST /api/logs/{loan_id}/returns
    # Create a return for book loan(:loan_id)
    post(summary: 'return a book') do
      # Produce response with 201 status code if the book is valid
      response(201, description: 'successful') do
        let(:loan_id) { Log.book_loan.unreturned.first.id }
      end
      # Return response with 422 status code if the loan is not valid
      response(422, description: 'book loan is not valid') do
        before do
          Log.book_loan.last.update_attribute(:returned, true)
        end
        let(:loan_id) { Log.book_loan.last.id }
      end
      # Return response with 404 status code if the loan doesn't exists
      response(404, description: 'book loan does not exists') do
        let(:loan_id) { 999_999_999 }
      end
    end
  end

  # book_loan logs create resource path
  path '/api/logs/{book_id}/loans' do
    # book_id path parameter def
    parameter 'book_id', in: :path, type: :string
    # Authorization header parameter
    parameter 'Authorization', in: :header, type: :string
    # Authorization header value
    let(:Authorization) { "Bearer #{headers(user.id)['Authorization']}" }

    # POST /api/logs/{book_id}/loans
    # Loan a book(:book_id)
    post(summary: 'loan a book') do
      # Produce response with 201 status code
      response(201, description: 'successful') do
        let(:book_id) { Book.available.first.id }
      end
      # Return response with 422 status code if the book is not available
      response(422, description: 'book is not available') do
        before do
          Book.last.update_attribute(:available, false)
        end
        let(:book_id) { Book.last.id }
      end
      # Return response with 404 status code if the book doesn't exists
      response(404, description: 'book does not exists') do
        let(:book_id) { 999_999_999 }
      end
    end
  end
end
