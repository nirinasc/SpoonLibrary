class API::CategoriesController < API::ApplicationController
    
    def index
        q = Category.ransack(params[:q])
        categories = q.result.order(id: :desc) 
        json_response_resources(categories)
    end
end