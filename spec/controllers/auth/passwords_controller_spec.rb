require 'rails_helper'

# Auth::PasswordsController Controller Tests Spec
RSpec.describe Auth::PasswordsController, type: :controller do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  # forgot password page tests
  describe 'GET #new' do
    let(:user) { FactoryBot.create(:user) }

    # when the user is not yet logged
    context 'when the user is not authenticated' do
      before do
        get :new
      end

      # expect response to have 200 status code
      it 'return a 200 response' do
        expect(response).to have_http_status(200)
      end

      # expect response to render the passwod forgot form template
      it 'render the new template' do
        expect(response).to render_template(:new)
      end
    end

    # when the user is already logged
    context 'when the user is authenticated' do
      before do
        sign_in user
        get :new
      end

      # expect response to redirect to store home
      it 'redirect to store index path' do
        expect(response).to redirect_to(store_index_path)
      end
    end
  end

  # forgot password post tests
  describe 'POST #create' do
    # when the email address posted exists
    context 'when the email exists' do
      before do
        FactoryBot.create(:user, email: 'john@example.com')
        post :create, params: { user: { email: 'john@example.com' } }
      end

      # it send email for instructions
      it 'send instructions email' do
        expect(ActionMailer::Base.deliveries.count).to eq 1
      end

      # expect response to send instructions message
      it 'send instructions message' do
        expect(flash[:notice]).to eq(I18n.t('devise.passwords.send_instructions'))
      end

      # expect response to redirect to login page
      it 'redirect to login path' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    # when the email address posted does not exists
    context 'when the email does not exists' do
      before do
        post :create, params: { user: { email: 'nonexistantemail@example.com' } }
      end

      # it assign errors to resource
      it 'assign errors  to resource' do
        expect(subject.instance_eval { resource }.errors).to_not be_empty
      end

      # the login form template is rerendered
      it "re-renders the 'new' template" do
        expect(response).to render_template('new')
      end
    end
  end

  # reset password page tests
  describe 'GET #edit' do
    let(:user) { FactoryBot.create(:user) }

    # when the user is not yet logged
    context 'when the user is not authenticated' do
      # when the reset password token passed in query is not valid
      context 'when the reset password token is present' do
        before do
          get :edit
        end

        it 'redirects to login page' do
          expect(response).to redirect_to(new_user_session_path)
        end

        it 'send a token missing alert' do
          expect(flash[:alert]).to eq(I18n.t('devise.passwords.no_token'))
        end
      end

      # when the reset password token is present in query
      context 'when the reset password token is present' do
        before do
          get :edit, params: { reset_password_token: 'token' }
        end

        # expect response to have 200 status code
        it 'return a 200 response' do
          expect(response).to have_http_status(200)
        end

        # expect response to render the passwod reset form template
        it 'render the new template' do
          expect(response).to render_template(:edit)
        end
      end
    end

    # when the user is already logged
    context 'when the user is authenticated' do
      before do
        sign_in user
        get :edit
      end

      # expect response to redirect to store home
      it 'redirect to store index path' do
        expect(response).to redirect_to(store_index_path)
      end
    end
  end

  # update password tests
  describe 'PUT #update' do
    let(:user) { FactoryBot.create(:user) }

    # when attributes are valid
    context 'when attributes are valid' do
      before do
        put :update, params: { user: {
          'reset_password_token' => user.send_reset_password_instructions,
          'password' => '1234546789',
          'password_confirmation' => '1234546789'
        } }
      end

      # expect the user to be automatically logged
      it 'log the user in' do
        expect(subject.instance_eval { current_user }).to eq(user)
      end

      it 'notice a successfull password change' do
        expect(flash[:notice]).to eq(I18n.t('devise.passwords.updated'))
      end

      # expect response to redirect to store home
      it 'redirect to store index path' do
        expect(response).to redirect_to(store_index_path)
      end
    end

    # when attributes are not valid
    context 'when attributes are not valid' do
      before do
        put :update, params: { user: {
          'reset_password_token' => user.send_reset_password_instructions,
          'password' => '12345467',
          'password_confirmation' => '1234546789'
        } }
      end

      it 'assign errors into resource' do
        expect(subject.instance_eval { resource }.errors).to_not be_empty
      end

      it 'rerender the edit form template' do
        expect(response).to render_template(:edit)
      end
    end
  end
end
