module API::V1
  # V1 API Books Comment Resources
  class CommentsController < API::V1::ApplicationController
    # before all, retrieve the parent book (:book_id param)
    before_action :retrieve_book

    # GET /api/books/:book_id/comments
    # return comments of book with id :book_id
    def index
      comments = @book.comments.includes(:user).order(id: :desc)
      render json: comments, status: :success
    end

    # POST /api/books/book_id/comments
    # Create a new comment of book :book_id
    # Return the new comment
    def create
      comment_params = params.require(:comment).permit(:content)
      new_record = Comment.create!(user: current_user, book: @book, content: comment_params[:content])
      comment = Comment.includes(:user).find(new_record.id)
      render json: comment, status: :success
    end

    private

    # Return the parent book with id :book_id
    def retrieve_book
      @book = Book.find(params[:book_id])
    end
  end
end
