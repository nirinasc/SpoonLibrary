require 'rails_helper'

# LogsController Controller Tests Spec
RSpec.describe LogsController, type: :controller do
  # create a library
  let(:library) { FactoryBot.create(:library) }
  # create categories
  let(:categories) do
    categories = []
    3.times { categories << FactoryBot.create(:category) }
    return categories
  end
  # define the user who issue next requests
  let(:user) { FactoryBot.create(:user, active: true) }

  # fill db with books, book loan and book returns before all
  before do
    10.times do |index|
      book = FactoryBot.create(:book, library: library, categories: categories)
      next if index < 5

      book_loan = FactoryBot.create(:book_loan, user: user, book: book, returned: false)
      # create book returns for 3 last loans
      FactoryBot.create(:book_return, user: user, book: book, loan: book_loan) if index > 6
    end
  end

  shared_examples 'user not authenticated' do
    # expect response to redirect to login page
    it 'redirect to login path' do
      expect(response).to redirect_to(new_user_session_path)
    end

    # expect a sign in necessity alert
    it 'send a need to log alert' do
      expect(flash[:alert]).to eq(I18n.t('devise.failure.unauthenticated'))
    end
  end

  # loans action method tests
  describe 'GET #loans' do
    context 'when the user is authenticated' do
      let(:loans) do
        Log.book_loan.includes(:book).where(user: user).ransack
           .result.paginate(page: nil, per_page: 20).order(id: :desc)
      end

      before do
        sign_in user
        get :loans
      end

      it 'assigns @loans' do
        expect(assigns(:loans)).to eq(loans)
      end

      it 'responds successfully' do
        expect(response).to have_http_status(200)
      end

      it 'render the loans template' do
        expect(response).to render_template(:loans)
      end
    end
    # when the user is not yet logged
    context 'when the user is not authenticated' do
      before do
        get :loans
      end

      include_examples 'user not authenticated'
    end
  end

  # returns action method tests
  describe 'GET #returns' do
    context 'when the user is authenticated' do
      let(:returns) do
        Log.book_return.includes(:book).where(user: user).ransack
           .result.paginate(page: nil, per_page: 20).order(id: :desc)
      end

      before do
        sign_in user
        get :returns
      end

      it 'assigns @returns' do
        expect(assigns(:returns)).to eq(returns)
      end

      it 'responds successfully' do
        expect(response).to have_http_status(200)
      end

      it 'render the returns template' do
        expect(response).to render_template(:returns)
      end
    end
    # when the user is not yet logged
    context 'when the user is not authenticated' do
      before do
        get :returns
      end

      include_examples 'user not authenticated'
    end
  end

  # returning action method tests
  describe 'POST #returning' do
    # when the user is not authenticated
    context 'when the user is authenticated' do
      before do
        sign_in user
      end
      # when the loan is not yet returned
      context 'when the loan is not yet returned' do
        before do
          post :returning, params: { loan: Log.book_loan.unreturned.first.id }
        end

        it 'send a success notice message' do
          expect(flash[:notice]).to eq('You have successfully returned that book')
        end

        it 'redirects to #returns' do
          expect(response).to redirect_to(returns_path)
        end
      end
      # when the loan was already returned
      context 'when the loan is already returned' do
        before do
          post :returning, params: { loan: Log.book_loan.where(returned, true).first.id }

          it 'send an alert containing the first validation error message' do
            book_return = assigns(:book_return)
            expect(flash[:alert]).to eq(book_return.errors.full_messages.first)
          end

          it 'redirects to #loans' do
            expect(response).to redirect_to(loans_path)
          end
        end
      end
      # when the loan does not exists
      context 'when the loan does not exists' do
        it 'raise Record Not Found Error' do
          expect { post :returning, params: { loan: 999_999 } }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
    # when the user is not yet logged
    context 'when the user is not authenticated' do
      before do
        post :returning, params: { loan: 123 }
      end

      include_examples 'user not authenticated'
    end
  end
end
