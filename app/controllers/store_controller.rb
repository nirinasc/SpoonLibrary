# @author nirina
# StoreController Class
class StoreController < ApplicationController
  # deny non authenticated user to enter served pages
  before_action :authenticate_user!
  before_action :set_current_user

  # GET /store/
  # show list of all books
  # filters can be applied, especially on categories an libraries
  # @see https://github.com/activerecord-hackery/ransack
  # @returns [ActionView::Renderer] view/store/index.html
  def index
    # prepare parameters filter
    qparams = params[:q].present? ? params[:q] : {}
    qparams['library_id_eq'] = params[:library] if params[:library].present?
    # retrieve all libratries
    @libraries = Library.all
    # retrieve all books and apply filters
    @q = Book.ransack(qparams)
    # retrive all categories
    @categories = Category.all
    # apply pagination to book list
    @books = @q.result.paginate(page: params[:page], per_page: 20).order(id: :desc)
  end

  # GET /store/:id (friendly Id)
  # show book details (book with its comments)
  # @see https://github.com/norman/friendly_id
  # @returns [ActionView::Renderer] view/store/show.html
  # @return [ActionView::Renderer] default 404 page if the book does not exists
  def show
    # retrieve the book with friendly :id
    @book = Book.friendly.find(params[:id])
    # create a blank comment
    @comment = Comment.new
  end
end
