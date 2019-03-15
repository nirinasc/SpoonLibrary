# spec/commands/authorize_jwt_request_spec.rb
require 'rails_helper'

RSpec.describe AuthorizeJWTRequest do
  # Create test user
  let(:active_user) { FactoryBot.create(:user, active: true) }
  let(:inactive_user) { FactoryBot.create(:user) }
  # Mock `Authorization` header
  let(:active_user_header) { { 'Authorization' => token_generator(active_user.id) } }
  let(:inactive_user_header) { { 'Authorization' => token_generator(inactive_user.id) } }

  # Test Suite for AuthorizeApiRequest#call
  # This is our entry point into the service class
  describe '#call' do
    # returns user object when request is valid
    context 'when valid request' do
      it 'returns user object' do
        command = described_class.call(active_user_header)
        expect(command.result).to eq(active_user)
      end
    end

    # returns error when invalid request
    context 'when invalid request' do
      # return inactive account error when user is not active
      context 'when account inactive' do
        it 'raises an non active account error' do
          expect { described_class.call(inactive_user_header) }
            .to raise_error(API::JWTExceptionHandler::InactiveAccount, 'Account not active')
        end
      end

      # return missing token error when token is missing
      context 'when missing token' do
        it 'raises a MissingToken error' do
          expect { described_class.call }
            .to raise_error(API::JWTExceptionHandler::MissingToken, 'Missing token')
        end
      end

      # return invalid token error when token is invalid
      context 'when invalid token' do
        it 'raises an InvalidToken error' do
          expect { described_class.call('Authorization' => token_generator(5)) }
            .to raise_error(API::JWTExceptionHandler::InvalidToken, /Invalid token/)
        end
      end

      # return invalid token error when token is expired
      context 'when token is expired' do
        let(:header) { { 'Authorization' => expired_token_generator(active_user.id) } }

        it 'raises JWTExceptionHandler::ExpiredSignature error' do
          expect { described_class.call(header) }
            .to raise_error(
              API::JWTExceptionHandler::InvalidToken,
              /Signature has expired/
            )
        end
      end

      context 'fake token' do
        let(:header) { { 'Authorization' => 'foobar' } }

        it 'handles JWT::DecodeError' do
          expect { described_class.call(header) }
            .to raise_error(
              API::JWTExceptionHandler::InvalidToken,
              /Not enough or too many segments/
            )
        end
      end
    end
  end
end
