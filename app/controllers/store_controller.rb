class StoreController < ApplicationController

    before_action :authenticate_user!
    
    def index
        @q = Book.ransack(params[:q])
        @categories = Category.all
        @books = @q.result.includes(:library).paginate(:page => params[:page], :per_page => 20).order(id: :desc)    
    end

    def show

    end
end
