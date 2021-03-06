# spec/comments/jwt_authenticate_user.rb
require 'rails_helper'

RSpec.describe JWTAuthenticateUser do
  # create test user
  let(:nonactive_user) { FactoryBot.create(:user) }
  let(:active_user) { FactoryBot.create(:user, active: true) }

  # Test suite for AuthenticateUser#call
  describe '#call' do
    # When credentials are valid
    context 'when valid credentials' do
      # return a token when the user is active
      context 'when user is active' do
        it 'returns an auth token' do
          token = described_class.call(active_user.username, active_user.password)
          expect(token).not_to be_nil
        end
      end

      # return an error message when the user is not active
      context 'when user is not active' do
        it 'raise an authentication error with inactive account message' do
          expect { described_class.call(nonactive_user.username, nonactive_user.password) }
            .to raise_error(
              API::JWTExceptionHandler::InactiveAccount,
              /Account not active/
            )
        end
      end
    end

    # raise Authentication Error when invalid request
    context 'when invalid credentials' do
      it 'raises an authentication error with invalid credential message' do
        expect { described_class.call('foo', 'bar') }
          .to raise_error(
            API::JWTExceptionHandler::AuthenticationError,
            /Invalid credentials/
          )
      end
    end
  end
end
