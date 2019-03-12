##
# @author nirina
# @api
# @version 1.0
module API::V1
  # V1 API Books Comment Resources
  class CommentsController < API::V1::ApplicationController
    # before all, retrieve the parent book (:book_id param)
    before_action :retrieve_book

    # Retrieve specific book comments collection
    # @example GET /api/books/:book_id/comments
    #   :book_id = 1
    # @return [ActionDispatch::Response] JSON representation of the book's comments
    def index
      # retrieve comments from db, including the user
      comments = @book.comments.includes(:user).order(id: :desc)
      render json: comments, status: :success
    end

    # Create a new comment of book :book_id
    # @example POST /api/books/book_id/comments
    #   request body params = {:content: 'comment content'}
    # @return [ActionDispatch::Response] JSON representation of the new comment
    # @return [ActionDispatch::Response] JSON with :not_found status code if the book does not exists
    def create
      # define required params
      comment_params = params.require(:comment).permit(:content)
      # create the new comment by the current user for the book @book
      new_record = Comment.create!(user: current_user, book: @book, content: comment_params[:content])
      # render the recent created comment
      comment = Comment.includes(:user).find(new_record.id)
      render json: comment, status: :success
    end

    private

    # retrieve the book with id = params[:book_id]
    # @return [Book] the parent book
    # @raise [ActiveRecord::RecordNotFound] if the book does not exists
    def retrieve_book
      @book = Book.find(params[:book_id])
    end
  end
end
