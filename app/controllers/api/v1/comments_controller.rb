module API::V1
    class CommentsController < API::V1::ApplicationController

        before_action :retrieve_book
        
        def index
            comments = @book.comments.includes(:user).order(id: :desc)
            render json: comments , status: :ok
        end
    
        def create
           new_record = Comment.create!({ user: current_user, book: @book, content: comment_params[:content]})
           comment = Comment.includes(:user).find(new_record.id)
           render json: comment , status: :ok
        end
    
        private 
    
    
        def retrieve_book
            @book = Book.find(params[:book_id])
        end
    
        private
    
    
        def comment_params
            params.require(:comment).permit(:content)
        end
        
    end
end
