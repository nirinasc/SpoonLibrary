module API::V1
  # V1 API Libraries Resources
  class LibrariesController < API::V1::ApplicationController
    # GET /api/libraries
    # Searchable by using ransack gem https://github.com/activerecord-hackery/ransack
    # Return libraries list
    def index
      q = Library.ransack(params[:q])
      libraries = q.result.order(id: :desc)
      render json: libraries, status: :ok
    end
  end
end
