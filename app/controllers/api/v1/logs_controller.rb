module API::V1
    class LogsController < API::V1::ApplicationController

        def loans
            q = Log.book_loan.includes(:book).where(user: current_user).ransack(params[:q])
            loans = q.result.paginate(:page => params[:page], :per_page => 20).order(id: :desc) 
            render json: loans , status: :ok
        end
    
        def returns
            q = Log.book_return.includes(:book).where(user: current_user).ransack(params[:q])
            returns = q.result.paginate(:page => params[:page], :per_page => 20).order(id: :desc) 
            render json: returns , status: :ok
    
        end
    
        def create_loan
            book = Book.find(params[:book_id])
            book_loan = Log.create!(user:current_user,book:book,classification:Log.classifications[:book_loan],date:DateTime.now,due_date: 3.weeks.from_now);
            render json: book_loan , status: :ok
        end
    
        def create_return
            loan = Log.find(params[:loan_id])
            book_return = Log.create!(user:current_user,book: loan.book, loan: loan,classification:Log.classifications[:book_return],date:DateTime.now)
            render json: book_return , status: :ok
        end
    end
end