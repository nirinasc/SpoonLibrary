# @author nirina
require 'swagger_helper'

RSpec.describe 'API::V1:Books', type: :request, capture_examples: true do
  # creeate an authenticated user
  let(:user) { FactoryBot.create(:user, active: true) }
  # Fill in the db with 10 books
  let(:number_of_books) { 30 }

  before do
    # create 2 library
    libraries = []
    2.times do |index|
      libraries << FactoryBot.create(:library, name: "library-#{index}")
    end
    # create 3 categories first
    categories = []
    3.times do |index|
      categories << FactoryBot.create(:category, name: "category-#{index}")
    end

    # create number_of_books books
    number_of_books.times do |index|
      FactoryBot.create(
        :book,
        name: "book-#{index}",
        available: Faker::Boolean.boolean,
        library: index < number_of_books - 10 ? libraries[0] : libraries[1],
        categories: index < number_of_books - 4 ? [categories[Faker::Number.between(0, 1)]] : [categories[2]]
      )
    end
  end

  # books resource path
  path '/api/books' do
    # GET /api/books
    # optional query param q (ex: q[name_cont]=book_name)
    # @see https://github.com/activerecord-hackery/ransack
    get(summary: 'books list') do
      produces 'application/json'
      parameter 'Authorization', in: :header, type: :string
      # book name filter query param
      parameter 'q[name_cont]', in: :query, type: :string
      # book categories filter query param
      parameter 'q[categories_id_eq]', in: :query, type: :string
      # book library filter query param
      parameter 'q[library_id_eq]', in: :query, type: :string

      # Expect Response with success
      response(200, description: 'successful') do
        # define valid auth header value
        let(:Authorization) { "Bearer #{headers(user.id)['Authorization']}" }

        # When no filter is applied
        context 'When there is no filter' do
          # all books must be returned
          it 'return all books' do
            books_number_per_page = 20
            if number_of_books < books_number_per_page
              expect(json.count).to eq(number_of_books)
            else
              expect(json.count).to eq(books_number_per_page)
            end
          end
        end

        # When a name filter is applied
        context 'When a name filter is applied' do
          let(:'q[name_cont]') { 'book-3' }

          # Only books which name contains filter value appear
          it 'return the filtered books' do
            expect(json.first['name']).to eq('book-3')
            expect(json.count).to eq(1)
          end
        end

        # When a category filter is applied
        context 'When a category filter is applied' do
          let(:'q[categories_id_eq]') { Category.last.id }

          # Only books belongs to category id 3 are returned
          it 'return the filtered books' do
            expect(json.count).to eq(4)
          end
        end

        # When a library filter is applied
        context 'When a library filter is applied' do
          let(:'q[library_id_eq]') { Library.last.id }

          # Only books which name contains filter value appear
          it 'return the filtered category' do
            expect(json.count).to eq(10)
          end
        end
      end
    end
  end

  # book detail resource path
  path '/api/books/{id}' do
    # GET /api/books/:id
    get(summary: 'show book detail') do
      produces 'application/json'
      parameter 'Authorization', in: :header, type: :string
      parameter 'id', in: :path, type: :string
      let(:Authorization) { "Bearer #{headers(user.id)['Authorization']}" }

      # Expect response with success status code when book id exists
      response(200, description: 'successful') do
        let(:last_book_id) { Book.last.id }
        let(:id) { last_book_id }

        # response must contains id eq to current book id
        it 'contains the current book info' do
          expect(json['id']).to eq(last_book_id)
        end
      end

      # Expect response with :not_found status code when book id does not exists
      response(404, description: '404 Not Found') do
        let(:id) { 999_999_999_999_999_999 }
      end
    end
  end
end
