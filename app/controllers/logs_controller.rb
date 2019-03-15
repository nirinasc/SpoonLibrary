# @author nirina
# LogsController Class
class LogsController < ApplicationController
  # deny non authenticated user to enter served pages
  before_action :authenticate_user!
  before_action :set_current_user

  # GET /logs/loans
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

  # GET /logs/returns
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

  # POST /logs/:loan/returns
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
      redirect_to returns_path, notice: 'You have successfully returned that book'
    else
      # redirect to list of loans page
      redirect_to loans_path, alert: @book_return.errors.full_messages.first
    end
  end
end
