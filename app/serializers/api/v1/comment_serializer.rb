module API::V1
  # V1 API Comment Model Serializer
  class CommentSerializer < ActiveModel::Serializer
    attributes :id, :user, :content, :created_at
    # comment user attributes
    def user
      {
        username: object.user.username
      }
    end
  end
end
