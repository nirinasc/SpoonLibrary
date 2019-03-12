##
# @author nirina
# @api
# @version 1.0
module API::V1
  # V1 API Libraries Resources
  class LibrariesController < API::V1::ApplicationController
    # Retrieve libraries collection
    # Filters can be applied
    # @example GET /api/libraries?q[name_cont]=library_name
    #   params[:q] = {:name_cont => 'library_name'}
    # @see https://github.com/activerecord-hackery/ransack
    # @returns [ActionDispatch::Response] JSON representation of libraries list
    def index
      q = Library.ransack(params[:q])
      libraries = q.result.order(id: :desc)
      render json: libraries, status: :ok
    end
  end
end
