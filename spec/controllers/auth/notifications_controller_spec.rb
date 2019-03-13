# @author nirina
require 'rails_helper'

# Auth::NotificationsController Controller Tests Spec
RSpec.describe Auth::NotificationsController, type: :controller do
  # success_signup action method tests
  describe 'GET #success_signup' do
    context 'when the success signup notice is present' do
      it 'render the success signup template' do
        get :success_signup, flash: { 'notice': I18n.t('devise.registrations.signed_up_but_inactive') }
        expect(response).to render_template('success_signup')
      end
    end

    context 'when there is notice but the content is not equal to the success signup message' do
      it 'is redirected to the root path' do
        get :success_signup, flash: { 'notice': 'just a dummy message...' }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when there is no notice message in the flash' do
      it 'is redirected to the root path' do
        get :success_signup
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
