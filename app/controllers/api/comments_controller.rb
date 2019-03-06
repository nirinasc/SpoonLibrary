class API::CommentsController < API::ApplicationController

    before_action :retrieve_book
    
    def index
        comments = @book.comments.includes(:user).order(id: :desc)

        json_response_resources(comments, include: {
            user: { 
                only: [:username]
            }
        }, except: [:user_id, :updated_at])
    end

    def create
       new_record = Comment.create!({ user: current_user, book: @book, content: comment_params[:content]})
       comment = Comment.includes(:user).find(new_record.id)

       json_response_resources(comment, 
        include: {
            user: { 
                only: [:username]
            }
        }, 
        except: [:user_id, :updated_at],
        status: :created
       )
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