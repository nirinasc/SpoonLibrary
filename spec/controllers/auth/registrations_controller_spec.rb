require 'rails_helper'

# Auth::RegistrationsController Controller Tests Spec
RSpec.describe Auth::RegistrationsController, type: :controller do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  # create action method tests
  describe 'POST #create' do
    # when posted attributes are valid
    context 'when the attributes are valid' do
      # expect a new user to be created successfully
      it 'creates a new member user' do
        expect do
          post :create, params: { user: FactoryBot.attributes_for(:user) }
        end.to change(User, :count).by(1)
      end

      # expect response to send welcome flash message 
      it 'generate success non active account registration notice' do
        post :create, params: { user: FactoryBot.attributes_for(:user) }
        expect(flash[:notice]).to eq(I18n.t('devise.registrations.signed_up'))
      end

      # expect response to redirect to store home
      it 'redirect to store index path' do
        post :create, params: { user: FactoryBot.attributes_for(:user) }
        expect(response).to redirect_to(store_index_path)
      end
    end

    # when posted attributes is not valid
    context 'when the model is not valid' do
      # no new user is created
      it 'does not create a new user' do
        expect do
          post :create, params: { user: FactoryBot.attributes_for(:user, username: nil) }
        end.to_not change(User, :count)
      end

      # the form template is rerendered
      it "re-renders the 'new' template" do
        post :create, params: { user: FactoryBot.attributes_for(:user, username: nil) }
        expect(response).to render_template('new')
      end
    end
  end
end
