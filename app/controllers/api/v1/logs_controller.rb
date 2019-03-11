module API::V1
  # V1 API Books Log Resources
  class LogsController < API::V1::ApplicationController
    # GET api/logs/loans
    # Searchable by using ransack gem https://github.com/activerecord-hackery/ransack
    # Return current user loans list
    def loans
      q = Log.book_loan.includes(:book).where(user: current_user).ransack(params[:q])
      loans = q.result.paginate(page: params[:page], per_page: 20).order(id: :desc)
      render json: loans, book_loan: true, status: :success
    end

    # GET api/logs/returns
    # Searchable by using ransack gem https://github.com/activerecord-hackery/ransack
    # Return current user returns list
    def returns
      q = Log.book_return.includes(:book).where(user: current_user).ransack(params[:q])
      returns = q.result.paginate(page: params[:page], per_page: 20).order(id: :desc)
      render json: returns, book_return: true, status: :success
    end

    # POST /api/logs/:book_id/loans
    # Create a loan for the book with id :book_id
    # Return the new loan record
    def create_loan
      book = Book.find(params[:book_id])
      book_loan = Log.create!(user: current_user, book: book, classification: Log.classifications[:book_loan],
                              date: DateTime.now, due_date: 3.weeks.from_now)
      render json: book_loan, book_loan: true, status: :success
    end

    # POST /api/logs/:loan_id/returns
    # Create a return of the loan with id :loan_id (log with id eq to :loan_id)
    # Return the new book return
    def create_return
      loan = Log.find(params[:loan_id])
      book_return = Log.create!(user: current_user, book: loan.book, loan: loan,
                                classification: Log.classifications[:book_return], date: DateTime.now)
      render json: book_return, book_return: true, status: :success
    end
  end
end
