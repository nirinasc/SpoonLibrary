module API::V1
    class BooksController < API::V1::ApplicationController
        
        def index
            q = Book.available.ransack(params[:q])
            books = q.result.paginate(:page => params[:page], :per_page => 20).order(id: :desc) 
            render json: books , status: :ok
        end

        def show
            book = Book.includes(:library,:categories).find(params[:id])
            render json: book , status: :ok
        end
    end
end