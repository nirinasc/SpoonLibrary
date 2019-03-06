class API::BooksController < API::ApplicationController
    
    def index
        q = Book.available.ransack(params[:q])
        books = q.result.paginate(:page => params[:page], :per_page => 20).order(id: :desc) 
        json_response_resources(books)
    end

    def show
        book = Book.includes(:library,:categories).find(params[:id])
        json_response_resources(book, include: {
            library: { 
                only: [:id, :name]
            }, 
            categories: {
                 only: [:id, :name]
            }
        }, except: [:library_id, :created_at, :updated_at])
    end

end