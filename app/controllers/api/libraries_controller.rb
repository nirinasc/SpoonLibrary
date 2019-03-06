class API::LibrariesController < API::ApplicationController
    
    def index
        q = Library.ransack(params[:q])
        libraries = q.result.order(id: :desc) 
        json_response_resources(libraries)
    end
end