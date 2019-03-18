require 'rails_helper'
# Admin::DashboardController Tests
RSpec.describe Admin::DashboardController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:admin) { FactoryBot.create(:user, role: User.roles[:admin]) }

  # index action method tests
  describe 'GET #index' do
    # 'when the user is not authenticated'
    context 'when the user is not authenticated' do
      before do
        get :index
      end

      # expect response to redirect to login page
      it 'redirect to login path' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    # 'when the authenticated user is a member'
    context 'when the authenticated user is a member' do
      before do
        sign_in user
        get :index
      end

      it 'redirect to login path' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    # 'when the authenticated user is an admin'
    context 'when the authenticated user is an admin' do
      before do
        sign_in admin
        get :index
      end

      it 'responds successfully' do
        expect(response).to have_http_status(200)
      end

      it 'render the index template' do
        expect(response).to render_template(:index)
      end
    end
  end
end
