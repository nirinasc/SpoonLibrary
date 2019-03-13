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
      it 'creates a new member user' do
        expect do
          post :create, params: { user: FactoryBot.attributes_for(:user) }
        end.to change(User, :count).by(1)
      end

      it 'generate success non active account registration notice' do
        post :create, params: { user: FactoryBot.attributes_for(:user) }
        expect(flash[:notice]).to eq(I18n.t('devise.registrations.signed_up_but_inactive'))
      end

      it 'redirect to success notification path' do
        post :create, params: { user: FactoryBot.attributes_for(:user) }
        expect(response).to redirect_to(notifications_success_signup_path)
      end
    end

    context 'when the model is not valid' do
      it 'creates a new member user' do
        expect do
          post :create, params: { user: FactoryBot.attributes_for(:user, username: nil) }
        end.to_not change(User, :count)
      end
      it "re-renders the 'new' template" do
        post :create, params: { user: FactoryBot.attributes_for(:user, username: nil) }
        expect(response).to render_template('new')
      end
    end
  end
end
