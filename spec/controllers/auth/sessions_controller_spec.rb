require 'rails_helper'

# Auth::SessionsController Controller Tests Spec
RSpec.describe Auth::SessionsController, type: :controller do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  let(:user) { FactoryBot.create(:user) }

  # new action method tests
  describe 'GET #new' do
    # when the user is already logged
    context 'when the user is already logged' do
      before do
        sign_in user
        get :new
      end

      # expect response to redirect to store home
      it 'redirect to store index path' do
        expect(response).to redirect_to(store_index_path)
      end
    end

    # when the user is not yiet logged
    context 'when the user is not yiet logged' do
      before do
        get :new
      end

      # expect response to have 200 status code
      it 'return a 200 response' do
        expect(response).to have_http_status(200)
      end

      # expect response to render the login form template
      it 'render the new template' do
        expect(response).to render_template(:new)
      end
    end
  end

  # create action method tests
  describe 'POST #create' do
    # when posted attributes are valid
    context 'when the credentials are valid' do
      before do
        FactoryBot.create(:user, username: 'demo', password: 'demo12345')
        post :create, params: { user: { username: 'demo', password: 'demo12345' } }
      end

      # expect the user to be successfully logged
      it 'log the user in' do
        logged_user = subject.instance_eval { current_user }
        expect(logged_user.username).to eq 'demo'
      end

      # expect response to send successfull login message
      it 'notice successfull login' do
        expect(flash[:notice]).to eq(I18n.t('devise.sessions.signed_in'))
      end

      # expect response to redirect to store home
      it 'redirect to store index path' do
        expect(response).to redirect_to(store_index_path)
      end
    end

    # when posted attributes is not valid
    context 'when the credentials are not valid' do
      before do
        post :create, params: { user: { username: 'nonexistantusername', password: 'nonexistantpassword' } }
      end

      # expect response to send invalid credentials message
      it 'alert invalid credentials message' do
        expect(flash[:alert]).to eq(I18n.t('devise.failure.invalid', authentication_keys: 'Username'))
      end

      # the login form template is rerendered
      it "re-renders the 'new' template" do
        expect(response).to render_template('new')
      end
    end
  end

  # destroy action method tests
  describe 'DELETE #destroy' do
    # when the user is logged
    context 'when the user logged' do
      before do
        sign_in user
        delete :destroy
      end

      # expect the user session to be destroy
      it 'log the user out' do
        expect(subject.instance_eval { current_user }).to be_nil
      end

      # expect response to send successfull log out message
      it 'send successfull sign out message' do
        expect(flash[:notice]).to eq(I18n.t('devise.sessions.signed_out'))
      end

      # expect response to redirect to root
      it 'redirect to store index path' do
        expect(response).to redirect_to(root_path)
      end
    end

    # when the user is not yiet logged
    context 'when the user is not yiet logged' do
      before do
        delete :destroy
      end

      # expect response to send already sign out message
      it 'send already sign out message' do
        expect(flash[:notice]).to eq(I18n.t('devise.sessions.already_signed_out'))
      end

      # expect response to redirect to root
      it 'redirect to store index path' do
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
