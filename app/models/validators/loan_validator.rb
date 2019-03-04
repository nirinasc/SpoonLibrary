class LoanValidator < ActiveModel::EachValidator
    def validate_each(record,attribute,value)
        unless value.book_loan? 
            record.errors[attribute] << (options[:message] || "is not a book loan")
        end
        if options[:returned].present?
            unless value.returned == options[:returned]
                record.errors[attribute] << (options[:message] || "ca not be assigned")
            end  
        end
    end
end