module API::V1
  # V1 API Library Model Serializer
  class LibrarySerializer < ActiveModel::Serializer
    attributes :id, :name, :country_code, :city, :address, :zip_code, :phone
  end
end
