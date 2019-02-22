require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user) { FactoryBot.build(:user) }

  shared_examples 'unable to persist user' do
    it 'can not be persisted' do 
      user.save
      expect(user).to_not be_persisted
    end
  end
  
  shared_examples 'able to persist user' do
    it 'can be persisted' do 
      user.save
      expect(user).to be_persisted
    end
  end

  specify do
    expect(user).to be_an(User)
  end

  context 'when all attributes are good' do
    include_examples 'able to persist user'
  end 

  ## email attribute validation
  context 'when email is not present' do
    before do
      user.email = nil
      user.valid?
    end
    it 'get email attribute presence error' do
      expect(user.errors.details[:email]).to include({:error=>:blank})   
    end
    include_examples 'unable to persist user'
  end

  context 'when email already exists' do
    before do
      another_user = FactoryBot.create(:user, username: 'erick', email: user.email)
      user.valid?
    end
    it 'get email attribute uniqueness error' do
      expect(user.errors.details[:email]).to include({:error=>:taken, :value=> user.email})    
    end
    include_examples 'unable to persist user'
  end

  context 'when email format is not valid' do
    before do
      user.email = 'notvalidformat'
      user.valid?
    end
    it 'get email attribute format error' do
        expect(user.errors.details[:email]).to include({:error=>:invalid, :value=> user.email})   
    end
    include_examples 'unable to persist user'
  end


  ## username attribute validation
  context 'when username is not present' do
    before do
        user.username = nil
        user.valid?
    end
    it 'get username attribute presence error' do
        expect(user.errors.details[:username]).to include({:error=>:blank})    
    end
    include_examples 'unable to persist user'
  end

  context 'when username already exists' do
    before do
        another_user = FactoryBot.create(:user, username: user.username)
        user.valid?
    end
    it 'get username attribute uniqueness error' do
        expect(user.errors.details[:username]).to include({:error=>:taken, :value=> user.username}) 
    end
    include_examples 'unable to persist user'
  end

  context 'when username format is not valid' do
    before do
        user.username = 'notvalidformat*@'
        user.valid?
    end
    it 'get username attribute format error' do
        expect(user.errors.details[:username]).to include({:error=>:invalid, :value=> user.username})  
    end
    include_examples 'unable to persist user'
  end

  ## password attribute validation
  context 'when password is not present' do
    before do
        user.password = nil
        user.valid?
    end
    it 'get password attribute presence error' do
        expect(user.errors.details[:password]).to include({:error=>:blank}) 
    end
    include_examples 'unable to persist user'
  end

  
  ## role attribute validation
  context 'when role is not present' do
    before do
        user.role = nil
        user.valid?
    end
    it 'get role attribute presence error' do
        expect(user.errors.details[:role]).to include({:error=>:blank})
    end
    include_examples 'unable to persist user'
  end

  context 'when role value is not valid' do
    it 'get role not valid error' do
        expect{ user.role = 999 }.to raise_error(ArgumentError)
    end
  end

  ## When FirstName is not present
  context 'when firstname is not present' do
    before do
        user.firstname = nil
    end
    include_examples 'able to persist user'
  end
  
  ## When LastName is not present
  context 'when lastname is not present' do
    before do
        user.lastname = nil
    end
    include_examples 'able to persist user'
  end

  ## When countryCode is not present
  context 'when country_code is not present' do
    before do
        user.country_code = nil
    end
    include_examples 'able to persist user'
  end
  
  ## When city is not present
  context 'when city is not present' do
    before do
        user.city = nil
    end
    include_examples 'able to persist user'
  end
  
  ## When address is not present
  context 'when address is not present' do
    before do
        user.address = nil
    end
    include_examples 'able to persist user'
  end
  
  ## When zip_code is not present
  context 'when country_code is not present' do
    before do
        user.zip_code = nil
    end
    include_examples 'able to persist user'
  end

  ## When phone is not present
  context 'when phone is not present' do
    before do
        user.phone = nil
    end
    include_examples 'able to persist user'
  end

end
