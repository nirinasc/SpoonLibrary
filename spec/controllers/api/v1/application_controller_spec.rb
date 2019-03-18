# @author nirina
require 'rails_helper'

# API::V1::ApplicationController Controller Test Spec
RSpec.describe API::V1::ApplicationController, type: :controller do
  # create a valid user
  let!(:active_user) { FactoryBot.create(:user, active: true) }
  # create a non active user
  let!(:nonactive_user) { FactoryBot.create(:user, username: 'erick', active: false) }
  # create missing auth header
  let(:missing_headers) { { 'Authorization' => nil } }
  # create invalid auth header
  let(:invalid_headers) { { 'Authorization' => 'InvalidToken' } }

  # authenticate_request method tests spec
  describe '#authenticate_request' do
    # when the authorization header  token is present
    context 'when token is passed' do
      # when the token is valid and match to an active user
      context 'when the user is active' do
        before { allow(request).to receive(:headers).and_return(headers(active_user.id).except('Content-Type')) }

        # It returns the current user
        it 'sets the current user' do
          expect(subject.instance_eval { authenticate_request }).to eq(active_user)
        end
      end

      # when the token is valid and match to a non active user
      context 'when the user is not active' do
        before { allow(request).to receive(:headers).and_return(headers(nonactive_user.id).except('Content-Type')) }

        # It raise an Invalid Account error
        it 'raises Account not valid error' do
          expect { subject.instance_eval { authenticate_request } }
            .to raise_error(API::JWTExceptionHandler::InactiveAccount, /Account not active/)
        end
      end

      # when the token is valid and match to a non active user
      context 'when the token is not valid' do
        before { allow(request).to receive(:headers).and_return(invalid_headers) }

        # It raise an Invalid Token error
        it 'raises InvalidToken error' do
          expect { subject.instance_eval { authenticate_request } }
            .to raise_error(API::JWTExceptionHandler::InvalidToken)
        end
      end
    end

    # When the authorization header  token is not present
    context 'when auth token is not passed' do
      before do
        allow(request).to receive(:headers).and_return(missing_headers)
      end

      # It raise a Missing Token error
      it 'raises MissingToken error' do
        expect { subject.instance_eval { authenticate_request } }
          .to raise_error(API::JWTExceptionHandler::MissingToken, /Missing token/)
      end
    end
  end
end
