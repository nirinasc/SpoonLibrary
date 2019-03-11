module API::V1
  # V1 API Category Model Serializer
  class CategorySerializer < ActiveModel::Serializer
    attributes :id, :name, :description
  end
end
