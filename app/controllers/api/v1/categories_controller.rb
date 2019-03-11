module API::V1
  # V1 API categories Resources
  class CategoriesController < API::V1::ApplicationController
    # GET /api/categories
    # Searchable by using ransack gem https://github.com/activerecord-hackery/ransack
    # Return categories list
    def index
      q = Category.ransack(params[:q])
      categories = q.result.order(id: :desc)
      render json: categories, status: :ok
    end
  end
end
