require 'rails_helper'

RSpec.describe Log, type: :model do

  context 'Validation' do
    subject(:user) { FactoryBot.create(:user)}
    subject(:book) { FactoryBot.create(:book, library: FactoryBot.create(:library)) }
    subject(:book_loan) { FactoryBot.build(:book_loan, user: user, book: book) }
    subject(:book_return) { FactoryBot.build(:book_return, user: user, book: book, loan: book_loan) }

    shared_examples 'unable to persist book loan log' do
      it 'can not be persisted' do 
        book_loan.save
        expect(book_loan).to_not be_persisted
      end
    end
    
    shared_examples 'able to persist book loan log' do
      it 'can be persisted' do 
        book_loan.save
        expect(book_loan).to be_persisted
      end
    end

    shared_examples 'unable to persist book return log' do
      it 'can not be persisted' do 
        book_return.save
        expect(book_return).to_not be_persisted
      end
    end
    
    shared_examples 'able to persist book return log' do
      it 'can be persisted' do 
        book_return.save
        expect(book_return).to be_persisted
      end
    end

    specify do
      expect(book_loan).to be_an(Log)
      expect(book_return).to be_an(Log)
    end

    context 'when all book loan attributes are good' do
      include_examples 'able to persist book loan log'
    end

    context 'when all book return attributes are good' do
      include_examples 'able to persist book return log'
    end
    
    ## user attribute validation
    context 'when user is not associated' do
      before do
        book_loan.user = nil
        book_loan.valid?
      end 
      it 'get a user attribute missing error' do
        expect(book_loan.errors.details[:user]).to include({:error=>:blank})
      end
      include_examples 'unable to persist book loan log'
    end
  
    ## book attribute validation
    context 'when book is not associated' do
      before do
        book_loan.book = nil
        book_loan.valid?
      end 
      it 'get a book attribute missing error' do
        expect(book_loan.errors.details[:book]).to include({:error=>:blank})
      end
      include_examples 'unable to persist book loan log'
    end

    ## classification attribute validation
    context 'when classification value is not valid' do
      it 'get classification not valid error' do
        expect{ book_loan.classification = 2 }.to raise_error(ArgumentError)
      end
    end

    ## date attribute validation
    context 'when date is not present' do
      before do
        book_loan.date = nil
        book_loan.valid?
      end
      it 'get date attribute invalid error' do
        expect(book_loan.errors.details[:date]).to include({:error=>:blank})   
      end
      include_examples 'unable to persist book loan log'
    end

    ## book_loan date attribute format validation
    context 'when date format is not valid' do
      before do
        book_loan.date = 'Invalid date'
        book_loan.valid?
      end
      it 'get date attribute invalid error' do
        expect(book_loan.errors.details[:date]).to include({:error=>:invalid_datetime, :restriction=>nil})
      end
      include_examples 'unable to persist book loan log'
    end

    ## book_loan due date attribute validation
    context 'when book_loan due date is not present' do
      before do
        book_loan.due_date = nil
        book_loan.valid?
      end
      it 'get due date attribute invalid error' do
        expect(book_loan.errors.details[:due_date]).to include({:error=>:blank})   
      end
      include_examples 'unable to persist book loan log'
    end

    context 'when book_loan due date format is not valid' do
      before do
        book_loan.due_date = 'Invalid date'
        book_loan.valid?
      end
      it 'get due date attribute invalid error' do
        expect(book_loan.errors.details[:due_date]).to include({:error=>:invalid_datetime, :restriction=>nil})
      end
      include_examples 'unable to persist book loan log'
    end

    context 'when book_loan due date is before the loan date' do
      before do
        book_loan.due_date = book_loan.date - 5
        book_loan.valid?
      end
      it 'get due date attribute after restriction error' do
        expect(book_loan.errors.details[:due_date]).to include({:error=>:after, :restriction=> book_loan.date })
      end
      include_examples 'unable to persist book loan log'
    end

    ##book_loan loan attribute validation
    context 'when another loan is associated to a book_loan' do
      before do 
        book_loan.loan = FactoryBot.build(:book_loan, user: user, book: book)  
        book_loan.valid?
      end
      it 'get loan attribute presence error' do
        expect(book_loan.errors.details[:loan]).to include({:error=>:present})
      end
      include_examples 'unable to persist book loan log'
    end

    ##book_return loan attribute validation
    context 'when a loan is not associated to return_loan' do
      before do 
        book_return.loan = nil  
        book_return.valid?
      end
      it 'get loan attribute missing error' do
        expect(book_return.errors.details[:loan]).to include({:error=>:blank})
      end
      include_examples 'unable to persist book return log'
    end

    ## book_return date attribute validation
    context 'when book_return date format is not valid' do
      before do
        book_return.date = 'Invalid date'
        book_return.valid?
      end
      it 'get date attribute invalid error' do
        expect(book_return.errors.details[:date]).to include({:error=>:invalid_datetime, :restriction=>nil})
      end
      include_examples 'unable to persist book return log'
    end

    ## book_return associated loan date attribute validation
    context 'when book_return date is before the associated loan date' do
      before do
        book_return.date = book_return.loan.date - 5
        book_return.valid?
      end

      it 'get date attribute after loan date restriction error' do
        expect(book_return.errors.details[:date]).to include({:error=>:after, :restriction=> book_return.loan.date })
      end
      include_examples 'unable to persist book return log'
    end

    ## book_return due date attribute validation
    context 'when book_return due date is not present' do
      before do
        book_return.due_date = nil
        book_return.valid?
      end
      include_examples 'able to persist book return log'
    end

  end
end
