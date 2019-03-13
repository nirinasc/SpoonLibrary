module API::V1
  # V1 API Log Model Serializer
  class LogSerializer < ActiveModel::Serializer
    attributes :id, :book, :classification, :date, :created_at
    # add due_date and returned field to the response if this represent a book loan
    attribute :due_date, if: -> { @instance_options[:book_loan].present? }
    attribute :returned, if: -> { @instance_options[:book_loan].present? }
    # add loan id field to the response if this represent a book return
    attribute :loan_id, if: -> { @instance_options[:book_return].present? }
    # associated book attribute
    def book
      {
        id: object.book.id,
        name: object.book.name
      }
    end
  end
end
