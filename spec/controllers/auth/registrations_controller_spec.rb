require 'rails_helper'

# Auth::RegistrationsController Controller Tests Spec
RSpec.describe Auth::RegistrationsController, type: :controller do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  # new action method tests
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

      # expect response to render the login form template
      it 'render the new template' do
        expect(response).to render_template(:new)
      end
    end

    # when the user is logged
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
      it 'generate welcome flash message' do
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

  # edit action method tests
  describe 'GET #edit' do
    let(:user) { FactoryBot.create(:user) }

    # when the user is not yet logged
    context 'when the user is not authenticated' do
      before do
        get :edit
      end

      # expect response to redirect to login page
      it 'redirect to login path' do
        expect(response).to redirect_to(new_user_session_path)
      end

      # expect a sign in necessity alert
      it 'send a need to log alert' do
        expect(flash[:alert]).to eq(I18n.t('devise.failure.unauthenticated'))
      end
    end

    # when the user is logged
    context 'when the user is authenticated' do
      before do
        sign_in user
        get :edit
      end

      # expect response to have 200 status code
      it 'return a 200 response' do
        expect(response).to have_http_status(200)
      end

      # expect response to render the edit form template
      it 'render the edit template' do
        expect(response).to render_template(:edit)
      end
    end
  end

  # update action method tests
  describe 'PUT #update' do
    let!(:user) { FactoryBot.create(:user) }

    shared_examples 'unable to update user' do
      # controller's resource contains errors
      it 'assign errors into resource' do
        expect(subject.instance_eval { resource }.errors).to_not be_empty
      end

      it 'does not update the user' do
        expect(user.reload.firstname).to_not eq 'new_firstname'
      end

      it 'rerender the edit template' do
        expect(response).to render_template(:edit)
      end
    end

    shared_examples 'user is successfully updated' do
      # expect the user to be updated
      it 'update the user attribute' do
        expect(user.reload.firstname).to eq 'new_firstname'
      end

      # expect response to redirect to user edit page
      it 'redirect to user edit page' do
        expect(response).to redirect_to(edit_user_registration_path)
      end
    end

    # when posted attributes are valid
    context 'when the attributes are valid' do
      # when the password is not updated
      context 'when the password is not updated' do
        before do
          sign_in user
          put :update, params: { user: {
            firstname: 'new_firstname'
          } }
        end

        include_examples 'user is successfully updated'
      end

      # when the password is updated
      context 'whe the password is updated' do
        before do
          sign_in user
          @params = { user: {
            'password' => '123456',
            'password_confirmation' => '123456',
            'firstname' => 'new_firstname'
          } }
        end

        # when the current password is not supplied
        context 'when the current password is not supplied' do
          before do
            put :update, params: @params
          end

          include_examples 'unable to update user'
        end

        # when the current password is not valid
        context 'when the current password is not valid' do
          before do
            @params[:user][:current_password] = 'not_valid_password'
            put :update, params: @params
          end

          include_examples 'unable to update user'
        end

        # when the current password is valid
        context 'when the current password is valid' do
          before do
            user.password = '1234562'
            user.save
            sign_in user
            @params[:user][:current_password] = '1234562'
            put :update, params: @params
          end

          include_examples 'user is successfully updated'
        end
      end
    end

    # when at least one attribute param is not valid
    context 'when the attributes are not valid' do
      before do
        # lets change the username to an existing username
        FactoryBot.create(:user, username: 'erick')
        @params = { user: { username: 'erick' } }
        sign_in user
        put :update, params: @params
      end

      include_examples 'unable to update user'
    end
  end
end
