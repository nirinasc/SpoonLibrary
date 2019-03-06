module ResponseHelper
    def json_response(object, status = :ok)
      render json: object, status: status
    end

    def json_response_resources(resources, except: [:created_at, :updated_at], include: {}, status: :ok)
      render json: resources, include: include, except: except, status: status 
    end

end