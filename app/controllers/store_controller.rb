class StoreController < ApplicationController

    before_action :authenticate_user!
    
    def index
        qparams = params[:q].present? ? params[:q] : {} 
        qparams.merge!({'library_id_eq' => params[:library]}) if params[:library].present?
        @libraries = Library.all;
        @q = Book.ransack(qparams)
        @categories = Category.all
        @books = @q.result.paginate(:page => params[:page], :per_page => 20).order(id: :desc)    
    end

    def show

    end
end
