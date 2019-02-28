class LoanValidator < ActiveModel::EachValidator
    def validate_each(record,attribute,value)
        unless value.book_loan? 
            record.errors[attribute] << (options[:message] || "is not a book loan")
        end
    end
end