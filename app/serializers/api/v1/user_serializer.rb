module API::V1
  # V1 API User Model Serializer
  class UserSerializer < ActiveModel::Serializer
    attributes :id, :firstname, :lastname, :username, :email, :role, :country_code, :city, :address, :zip_code, :phone, :created_at
  end
end
