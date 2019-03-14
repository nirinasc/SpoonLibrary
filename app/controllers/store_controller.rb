# @author nirina
# StoreController Class
class StoreController < ApplicationController
  # deny non authenticated user to enter served pages
  before_action :authenticate_user!

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

  # create a comment of book :id
  # @example POST /store/:id/comment
  #   request params = { content: 'comment content' }
  # Redirect to #show with success message if the comment is successfully created
  # Redirect to #show with error message if the comment is not valid
  # @return [ActionView::Renderer] default 404 page if the book does not exists
  def comments_create
    # retrieve the book to comment
    @book = Book.friendly.find(params[:id])
    # create a new comment by assigning it the book and the content param
    @comment = Comment.new(user: current_user, book: @book, content: params[:comment][:content])

    # check if the comment is valid
    if @comment.valid?
      # save the comment in db
      @comment.save
      # redirect to book show page with a success message
      redirect_to store_show_path, notice: 'Your comment has been successfully added'
    else
      # redirect to book show page with an error message
      redirect_to store_show_path, alert: @comment.errors.full_messages.first
    end
  end

  # POST '/store/:id/loan'
  # Create a loan for the book with id :id
  # Redirect to #show with success message if the book is successfully borrowed
  # Redirect to #loans with error message if the book is not available
  # @return [ActionView::Renderer] default 404 page if the book does not exists
  def loan
    # retrieve the book objet to be loaned
    @book = Book.friendly.find(params[:id])
    # create a new book loan instance by passing the book
    @book_loan = Log.new(
      user: current_user,
      book: @book,
      classification: Log.classifications[:book_loan],
      date: DateTime.now,
      due_date: 3.weeks.from_now
    )
    # check if the book loan attributes are valid
    if @book_loan.valid?
      # save the book loan in db
      @book_loan.save
      # redirect to book show page with a success message
      redirect_to store_show_path, notice: 'You have successfully borrowed this book'
    else
      # redirect to book show page with an error message
      redirect_to store_show_path, alert: 'An error occurred during the process, please contact the administrator'
    end
  end

  # GET /store/loans
  # show list of book loans performed by the current user
  # Filters can be applied
  # @see https://github.com/activerecord-hackery/ransack
  # @returns [ActionView::Renderer] view/store/loans.html
  def loans
    # retrieve logs of type book_loan, performed by the current user and apply params filter
    @q = Log.book_loan.includes(:book).where(user: current_user).ransack(params[:q])
    # apply pagination to the result above
    @loans = @q.result.paginate(page: params[:page], per_page: 20).order(id: :desc)
  end

  # GET /store/returns
  # show list of book returns performed by the current user
  # Filters can be applied
  # @see https://github.com/activerecord-hackery/ransack
  # @returns [ActionView::Renderer] view/store/returns.html
  def returns
    # retrieve logs of type book_return, performed by the current user and apply params filter
    @q = Log.book_return.includes(:book).where(user: current_user).ransack(params[:q])
    # apply pagination to the result above
    @returns = @q.result.paginate(page: params[:page], per_page: 20).order(id: :desc)
  end

  # POST /store/:loan/returns
  # Create a return of the loan with id :loan_id (log with id eq to :loan_id)
  # Redirect to #returns with success message if the book is returned successfully
  # Redirect to #loans with error message if bokk was already returned
  # @return [ActionView::Renderer] default 404 page if the loan does not exists
  def returning
    # retrieve the refered loan in which a book need to be returned
    @loan = Log.find(params[:loan])
    # create a new book return object by assigning the loan
    @book_return = Log.new(
      user: current_user,
      book: @loan.book,
      loan: @loan,
      classification: Log.classifications[:book_return],
      date: DateTime.now
    )
    # check if the book return is valid
    if @book_return.valid?
      # save the book return
      @book_return.save
      # redirect to list of book returns page
      redirect_to store_returns_path, notice: 'You have successfully returned that book'
    else
      # redirect to list of loans page
      redirect_to store_loans_path, alert: @book_return.errors.full_messages.first
    end
  end
end
