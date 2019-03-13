class BookValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.present?
      if options[:available].present?
        unless value.available == options[:available]
          record.errors[attribute] << (options[:message] || 'ca not be assigned')
        end
      end
    end
  end
end
