# @author nirina
# @api
# @version 1.0
module API::V1
  # V1 API Books Resources
  class BooksController < API::V1::ApplicationController
    # Retrieve books collection
    # Filters can be applied
    # @example GET /api/books?q[categories_id_eq]=2&q[name_cont]=book_name
    #   params[:q] = {:name_cont => 'book_name', :categories_id_eq => 2 }
    # @see https://github.com/activerecord-hackery/ransack
    # @returns [ActionDispatch::Response] JSON representation of the books list
    def index
      q = Book.ransack(params[:q])
      books = q.result.paginate(page: params[:page], per_page: 20).order(id: :desc)
      render json: books, status: :ok
    end

    # Retrive a book by its id
    # @example GET /api/book/:id
    #   params[:id] = 5
    # @return [ActionDispatch::Response] JSON representation of the book detail
    # @return [ActionDispatch::Response] JSON with :not_found status code if the book does not exists
    def show
      book = Book.includes(:library, :categories).find(params[:id])
      render json: book, library: true, categories: true, status: :ok
    end
  end
end
