class LoanValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message] || 'is not a book loan') unless value.book_loan?
    if options[:returned].present?
      unless value.returned == options[:returned]
        record.errors[attribute] << (options[:message] || 'ca not be assigned')
      end
    end
  end
end
