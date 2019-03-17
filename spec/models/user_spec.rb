require 'rails_helper'
# User Model Tests Spec
RSpec.describe User, type: :model do
  context 'Validation' do
    subject(:user) { FactoryBot.build(:user) }

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
        expect(user.errors.details[:email]).to include(error: :blank)
      end
      include_examples 'unable to persist user'
    end

    context 'when email already exists' do
      before do
        FactoryBot.create(:user, username: 'erick', email: user.email)
        user.valid?
      end
      it 'get email attribute uniqueness error' do
        expect(user.errors.details[:email]).to include(error: :taken, value: user.email)
      end
      include_examples 'unable to persist user'
    end

    context 'when email format is not valid' do
      before do
        user.email = 'notvalidformat'
        user.valid?
      end
      it 'get email attribute format error' do
        expect(user.errors.details[:email]).to include(error: :invalid, value: user.email)
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
        expect(user.errors.details[:username]).to include(error: :blank)
      end
      include_examples 'unable to persist user'
    end

    context 'when username already exists' do
      before do
        FactoryBot.create(:user, username: user.username)
        user.valid?
      end
      it 'get username attribute uniqueness error' do
        expect(user.errors.details[:username]).to include(error: :taken, value: user.username)
      end
      include_examples 'unable to persist user'
    end

    context 'when username format is not valid' do
      before do
        user.username = 'notvalidformat*@'
        user.valid?
      end
      it 'get username attribute format error' do
        expect(user.errors.details[:username]).to include(error: :invalid, value: user.username)
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
        expect(user.errors.details[:password]).to include(error: :blank)
      end
      include_examples 'unable to persist user'
    end

    ## role attribute validation
    context 'when role is not present' do
      before do
        user.role = nil
        user.valid?
      end
      it 'does not get role attribute presence error' do
        expect(user.errors[:role].size).to eq(0)
      end
      it 'get role member default role' do
        user.save
        expect(user.member?).to eq(true)
      end
    end

    context 'when role value is not valid' do
      it 'get role not valid error' do
        expect { user.role = 999 }.to raise_error(ArgumentError)
      end
    end

    ## active attribute validation
    context 'when active is not present' do
      before do
        user.active = nil
        user.valid?
      end
      it 'does not get active attribute presence error' do
        expect(user.errors[:active].size).to eq(0)
      end
      it 'get active default value to true' do
        user.save
        expect(user.active).to eq(true)
      end
    end

    ## When FirstName is not present
    context 'when firstname is not present' do
      before do
        user.firstname = nil
      end
      context 'when role is admin' do
        before do
          user.role = User.roles[:admin]
          user.valid?
        end
        it 'does not get firstname presence error' do
          expect(user.errors[:firstname].size).to eq(0)
        end
        include_examples 'able to persist user'
      end

      context 'when role differ from admin' do
        before do
          user.role = nil
          user.valid?
        end
        it 'get firstname presence error' do
          expect(user.errors.details[:firstname]).to include(error: :blank)
        end
        include_examples 'unable to persist user'
      end
    end

    ## When LastName is not present
    context 'when lastname is not present' do
      before do
        user.lastname = nil
      end
      context 'when role is admin' do
        before do
          user.role = User.roles[:admin]
          user.valid?
        end
        it 'does not get lastname presence error' do
          expect(user.errors[:lastname].size).to eq(0)
        end
        include_examples 'able to persist user'
      end

      context 'when role differ from admin' do
        before do
          user.role = nil
          user.valid?
        end
        it 'get lastname presence error' do
          expect(user.errors.details[:lastname]).to include(error: :blank)
        end
        include_examples 'unable to persist user'
      end
    end

    ## When countryCode is not present
    context 'when country_code is not present' do
      before do
        user.country_code = nil
      end
      context 'when role is admin' do
        before do
          user.role = User.roles[:admin]
          user.valid?
        end
        it 'does not get country_code presence error' do
          expect(user.errors[:country_code].size).to eq(0)
        end
        include_examples 'able to persist user'
      end

      context 'when role differ from admin' do
        before do
          user.role = nil
          user.valid?
        end
        it 'get country_code presence error' do
          expect(user.errors.details[:country_code]).to include(error: :blank)
        end
        include_examples 'unable to persist user'
      end
    end

    context 'when country_code value is not valid' do
      before do
        user.country_code = 'NOTVALIDCODE'
        user.valid?
      end
      it 'get country_code not valid error' do
        expect(user.errors.details[:country_code]).to include(error: :inclusion, value: 'NOTVALIDCODE')
      end
      include_examples 'unable to persist user'
    end

    ## When city is not present
    context 'when city is not present' do
      before do
        user.city = nil
      end
      context 'when role is admin' do
        before do
          user.role = User.roles[:admin]
          user.valid?
        end
        it 'does not get city presence error' do
          expect(user.errors[:city].size).to eq(0)
        end
        include_examples 'able to persist user'
      end

      context 'when role differ from admin' do
        before do
          user.role = nil
          user.valid?
        end
        it 'get city presence error' do
          expect(user.errors.details[:city]).to include(error: :blank)
        end
        include_examples 'unable to persist user'
      end
    end

    ## When address is not present
    context 'when address is not present' do
      before do
        user.address = nil
      end
      context 'when role is admin' do
        before do
          user.role = User.roles[:admin]
          user.valid?
        end
        it 'does not get address presence error' do
          expect(user.errors[:address].size).to eq(0)
        end
        include_examples 'able to persist user'
      end

      context 'when role differ from admin' do
        before do
          user.role = nil
          user.valid?
        end
        it 'get address presence error' do
          expect(user.errors.details[:address]).to include(error: :blank)
        end
        include_examples 'unable to persist user'
      end
    end

    ## When zip_code is not present
    context 'when zip_code is not present' do
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
end
