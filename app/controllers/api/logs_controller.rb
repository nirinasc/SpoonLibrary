class API::LogsController < API::ApplicationController

    def loans
        q = Log.book_loan.includes(:book).where(user: current_user).ransack(params[:q])
        loans = q.result.paginate(:page => params[:page], :per_page => 20).order(id: :desc) 
        json_response_resources(loans,
            include: { book: { only: [:id, :name] } },    
            except: [:user_id,:book_id,:loan_id,:updated_at]
        )
    end

    def returns
        q = Log.book_return.includes(:book).where(user: current_user).ransack(params[:q])
        returns = q.result.paginate(:page => params[:page], :per_page => 20).order(id: :desc) 
        json_response_resources(returns,
            include: { book: { only: [:id, :name] } },    
            except: [:user_id,:book_id,:due_date,:returned,:updated_at]
        )

    end

    def create_loan
        book = Book.find(params[:book_id])
        book_loan = Log.create!(user:current_user,book:book,classification:Log.classifications[:book_loan],date:DateTime.now,due_date: 3.weeks.from_now);
        
        json_response_resources(book_loan,
            include: { book: { only: [:id, :name] } },    
            except: [:user_id,:book_id,:loan_id,:updated_at],
            status: :created
        )
    end

    def create_return
        loan = Log.find(params[:loan_id])
        book_return = Log.create!(user:current_user,book: loan.book, loan: loan,classification:Log.classifications[:book_return],date:DateTime.now)

        json_response_resources(book_return,
            include: { book: { only: [:id, :name] } },    
            except: [:user_id,:book_id,:due_date,:returned,:updated_at]
        )
    end
    
end