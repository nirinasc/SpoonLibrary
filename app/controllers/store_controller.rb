class StoreController < ApplicationController

    before_action :authenticate_user!
    
    def index
        @categories = Category.all
        @books = Book.includes(:library).order(id: :desc)    
    end
end
