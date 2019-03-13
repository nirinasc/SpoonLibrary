class StoreController < ApplicationController
  before_action :authenticate_user!

  def index
    qparams = params[:q].present? ? params[:q] : {}
    qparams['library_id_eq'] = params[:library] if params[:library].present?
    @libraries = Library.all
    @q = Book.available.ransack(qparams)
    @categories = Category.all
    @books = @q.result.paginate(page: params[:page], per_page: 20).order(id: :desc)
  end

  def show
    @book = Book.friendly.find(params[:id])
    @comment = Comment.new
  end

  def comments_create
    @book = Book.friendly.find(params[:id])
    @comment = Comment.new(user: current_user, book: @book, content: params[:comment][:content])

    if @comment.valid?
      @comment.save
      redirect_to store_show_path, notice: 'Your comment has been successfully added'
    else
      redirect_to store_show_path, alert: @comment.errors.full_messages.first
    end
  end

  def loan
    @book = Book.friendly.find(params[:id])
    @book_loan = Log.new(user: current_user, book: @book, classification: Log.classifications[:book_loan], date: DateTime.now, due_date: 3.weeks.from_now)

    if @book_loan.valid?
      @book_loan.save
      redirect_to store_show_path, notice: 'You have successfully borrowed this book'
    else
      redirect_to store_show_path, alert: 'An error occurred during the process, please contact the administrator'
    end
  end

  def loans
    @q = Log.book_loan.includes(:book).where(user: current_user).ransack(params[:q])
    @loans = @q.result.paginate(page: params[:page], per_page: 20).order(id: :desc)
  end

  def returns
    @q = Log.book_return.includes(:book).where(user: current_user).ransack(params[:q])
    @returns = @q.result.paginate(page: params[:page], per_page: 20).order(id: :desc)
  end

  def returning
    @loan = Log.find(params[:loan])
    @book_return = Log.new(user: current_user, book: @loan.book, loan: @loan, classification: Log.classifications[:book_return], date: DateTime.now)

    if @book_return.valid?
      @book_return.save
      redirect_to store_returns_path, notice: 'You have successfully returned that book'
    else
      redirect_to store_loans_path, alert: @book_return.errors.full_messages.first
    end
  end
end
