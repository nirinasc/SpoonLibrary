##
# @author nirina
# @api
# @version 1.0
module API::V1
  # V1 API Books Log Resources
  class LogsController < API::V1::ApplicationController
    # Retrieve current user book loans collection
    # Filters can be applied
    # @example GET api/logs/loans?q[returned_eq]=true
    #   params[:q] = {:returned_eq => 'true'}
    # @see https://github.com/activerecord-hackery/ransack
    # @returns [ActionDispatch::Response] JSON representation of current user loans list
    def loans
      q = Log.book_loan.includes(:book).where(user: current_user).ransack(params[:q])
      loans = q.result.paginate(page: params[:page], per_page: 20).order(id: :desc)
      render json: loans, book_loan: true, status: :ok
    end

    # Retrieve current user book returns collection
    # Filters can be applied
    # @example GET api/logs/returns?q[book_id_eq]=5
    #   params[:q] = {:book_id_eq => 5}
    # @see https://github.com/activerecord-hackery/ransack
    # @returns [ActionDispatch::Response] JSON representation of current user returns list
    def returns
      q = Log.book_return.includes(:book).where(user: current_user).ransack(params[:q])
      returns = q.result.paginate(page: params[:page], per_page: 20).order(id: :desc)
      render json: returns, book_return: true, status: :ok
    end

    # Create a loan for the book with id :book_id
    # @example POST /api/logs/:book_id/loans
    #   with :book_id = 5
    # @return [ActionDispatch::Response] JSON representation of the new loan record
    # @return [ActionDispatch::Response] JSON with :not_found status code if the book does not exists
    # @return [ActionDispatch::Response] JSON with :unprocessable_entity status code if the loan could not be saved
    def create_loan
      book = Book.find(params[:book_id])
      book_loan = Log.create!(user: current_user, book: book, classification: Log.classifications[:book_loan],
                              date: DateTime.now, due_date: 3.weeks.from_now)
      render json: book_loan, book_loan: true, status: :created
    end

    # Create a return of the loan with id :loan_id (log with id eq to :loan_id)
    # @example POST /api/logs/:loan_id/returns
    # @return [ActionDispatch::Response] JSON representation of the new book return
    # @return [ActionDispatch::Response] JSON with :not_found status code if the book loan does not exists
    # @return [ActionDispatch::Response] JSON with :unprocessable_entity status code if the return could not be saved
    def create_return
      loan = Log.find(params[:loan_id])
      book_return = Log.create!(user: current_user, book: loan.book, loan: loan,
                                classification: Log.classifications[:book_return], date: DateTime.now)
      render json: book_return, book_return: true, status: :created
    end
  end
end
