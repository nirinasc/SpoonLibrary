module API::V1
  # V1 API Book Model Serializer
  class BookSerializer < ActiveModel::Serializer
    attributes :id, :name, :isbn, :author, :description, :cover_image, :number_of_pages,
               :format, :publisher, :pub_date, :language, :available, :created_at, :comments_count
    # include library association if :library option is present
    attribute :library, if: -> { @instance_options[:library].present? }
    # include categories association if :categories option is present
    attribute :categories, if: -> { @instance_options[:categories].present? }

    def library
      {
        id: object.library.id,
        name: object.library.name
      }
    end

    def categories
      object.categories.map do |category|
        {
          id: category.id,
          name: category.name
        }
      end
    end
  end
end
