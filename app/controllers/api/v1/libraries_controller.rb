module API::V1
    class LibrariesController < API::V1::ApplicationController
    
        def index
            q = Library.ransack(params[:q])
            libraries = q.result.order(id: :desc) 
            render json: libraries , status: :ok
        end
    end
end

