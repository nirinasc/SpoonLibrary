module API::V1
    class CategoriesController < API::V1::ApplicationController
    
        def index
            q = Category.ransack(params[:q])
            categories = q.result.order(id: :desc) 
            render json: categories , status: :ok
        end
    end
end
