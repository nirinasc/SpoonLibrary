# @author nirina
# Custom Book Validator class
class BookValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.present?
      if options[:available].present?
        record.errors[attribute] << (options[:message] || 'ca not be assigned') unless value.available == options[:available]
      end
    end
  end
end
