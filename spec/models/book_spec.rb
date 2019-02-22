require 'rails_helper'

RSpec.describe Book, type: :model do

  let(:library) { FactoryBot.create(:library) }
  let(:book) { FactoryBot.build(:book, library: library) }

  shared_examples 'unable to persist book' do
    it 'can not be persisted' do 
      book.save
      expect(book).to_not be_persisted
    end
  end
  
  shared_examples 'able to persist book' do
    it 'can be persisted' do 
      book.save
      expect(book).to be_persisted
    end
  end

  specify do
    expect(book).to be_an(Book)
  end

  context 'when all attributes are good' do
    include_examples 'able to persist book'
  end 

  ## library attribute validation
  context 'when library is not associated' do
     before do
      book.library = nil
      book.valid?
     end 
     it 'get a library attribute missing error' do
         expect(book.errors.details[:library]).to include({:error=>:blank})     
     end
     include_examples 'unable to persist book'
  end

  ## name attribute validation
  context 'when name is not present' do
    before do
      book.name = nil
      book.valid?
    end
    it 'get name attribute presence error' do
      expect(book.errors.details[:name]).to include({:error=>:blank})  
    end
    include_examples 'unable to persist book'
  end

  ## isbn attribute validation
  context 'when isbn is not present' do
    before do 
      book.isbn = nil
      book.valid?
    end
    it 'get isbn attribute presence error' do
      expect(book.errors.details[:isbn]).to include({:error=>:blank})    
    end
    include_examples 'unable to persist book'
  end

  context 'when isbn length is greater than 13' do
    before do
      book.isbn = '156545454-x-3641'
      book.valid?
    end
    it 'get isbn attribute length error' do
      expect(book.errors.details[:isbn]).to include({:error=>:too_long, :count=> 13})   
    end
    include_examples 'unable to persist book'
  end

  context 'when isbn value already exists' do
    before do
      another_book = FactoryBot.create(:book, library: library, isbn: book.isbn)
      book.valid?
    end
    it 'get isbn attribute uniqueness error' do
      expect(book.errors.details[:isbn]).to include({:error=>:taken, :value=> book.isbn})  
    end
    include_examples 'unable to persist book'
  end

  ## number_of_pages attribute validation
  context 'when number_of_pages is not supplied' do
    before do
      book.number_of_pages = nil
      book.valid?
    end
    it 'get number_of_pages attribute presence error' do
      expect(book.errors.details[:number_of_pages]).to include({:error=>:blank})    
    end
    include_examples 'unable to persist book'
  end

  context 'when number_of_pages is not a numeric value' do
    before do
      book.number_of_pages = 'NotNumeric15Value'
      book.valid?
    end
    it 'get number_of_pages attribute numericality error' do
      expect(book.errors.details[:number_of_pages]).to include({:error=>:not_a_number, :value=> "NotNumeric15Value"}) 
    end
    include_examples 'unable to persist book'
  end

  ## format attribute validation
  context 'when format is not present' do
    before do
      book.format = nil
      book.valid?
    end
    it 'get format attribute presence error' do
      expect(book.errors.details[:format]).to include({:error=>:blank}) 
    end
    include_examples 'unable to persist book'
  end

  context 'when format value is not valid' do
    it 'get format not valid error' do
      expect{ book.format = 2 }.to raise_error(ArgumentError)
    end
  end

  ## pub_date attribute validation
  context 'when pub_date is not supplied' do
    before do
      book.pub_date = nil
      book.valid?
    end
    it 'does not get pub_date attribute missing error' do
      expect(book.errors[:pub_date].size).to eq(0)     
    end
    include_examples 'able to persist book'
  end

  context 'when pub_date format is not valid' do
    before do
      book.pub_date = 'Invalid date'
      book.valid?
    end
    it 'get pub_date format not valid error' do
      expect(book.errors.details[:pub_date]).to include({:error=>:invalid_date, :restriction=>nil})
    end
    include_examples 'unable to persist book'
  end

  ## language attribute validation
  context 'when language is not present' do
    before do
      book.language = nil
      book.valid?
    end
    it 'get language attribute presence error' do
      expect(book.errors.details[:language]).to include({:error=>:blank})  
    end
    include_examples 'unable to persist book'
  end

  context 'when language value is not valid' do
    it 'get language not valid error' do
      expect{ book.language = 999 }.to raise_error(ArgumentError)
    end
  end

end
