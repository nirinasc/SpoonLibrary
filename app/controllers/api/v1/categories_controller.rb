##
# @author nirina
# @api
# @version 1.0
module API::V1
  # V1 API categories Resources
  class CategoriesController < API::V1::ApplicationController
    # Retrieve categories collection
    # Filters can be applied
    # @example GET /api/categories?q[name_cont]=category_name
    #   params[:q] = {:name_cont => 'category_name'}
    # @see https://github.com/activerecord-hackery/ransack
    # @returns [ActionDispatch::Response] JSON representation of categories list
    def index
      q = Category.ransack(params[:q])
      categories = q.result.order(id: :desc)
      render json: categories, status: :ok
    end
  end
end
