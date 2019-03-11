module API::V1
  # V1 API Books Resources
  class BooksController < API::V1::ApplicationController
    # GET /api/books
    # Returns books list
    def index
      q = Book.available.ransack(params[:q])
      books = q.result.paginate(page: params[:page], per_page: 20).order(id: :desc)
      render json: books, status: :success
    end

    # GET /api/book/:id
    # Return book detail with id :id
    def show
      book = Book.includes(:library, :categories).find(params[:id])
      render json: book, library: true, categories: true, status: :success
    end
  end
end
