require 'rails_helper'

# BooksController tests Spec
RSpec.describe BooksController, type: :controller do
  # create a library
  let(:library) { FactoryBot.create(:library) }
  # create categories
  let(:categories) do
    categories = []
    3.times { categories << FactoryBot.create(:category) }
    return categories
  end
  # create a book by assigning the library and categories
  let(:book) { FactoryBot.create(:book, library: library, categories: categories) }
  # define the user who issue next requests
  let(:user) { FactoryBot.create(:user, active: true) }

  before do
    # create 10 comments
    10.times do
      FactoryBot.create(:comment, user: user, book: book)
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

  # comments_create action method tests
  describe 'POST #comments_create' do
    # when the use is logged
    context 'when the user is authenticated' do
      before do
        sign_in user
      end
      # when the book id is valid
      context 'the book id is valid' do
        # when the comment is valid
        context 'when the comment is valid' do
          before do
            post :comments_create, params: { id: book.slug, comment: { content: 'A cool book' } }
          end
          it 'send a success notice message' do
            expect(flash[:notice]).to eq('Your comment has been successfully added')
          end
          it 'redirects to store book details page' do
            expect(response).to redirect_to(store_show_path(id: book.slug))
          end
        end

        # when the comment is not valid
        context 'when the comment is not valid' do
          before do
            post :comments_create, params: { id: book.slug, comment: { content: 'A' } }
          end
          it 'send an alert containing the first validation error message' do
            comment = assigns(:comment)
            expect(flash[:alert]).to eq(comment.errors.full_messages.first)
          end
          it 'redirects to store book details page' do
            expect(response).to redirect_to(store_show_path(id: book.slug))
          end
        end
      end

      # when the book id is not valid
      context 'when the book id is not valid' do
        it 'raises Record NotFound error' do
          expect do
            post :comments_create, params: { id: 999_999, comment: { content: 'A cool book' } }
          end .to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
    # when the user is not yet logged
    context 'when the user is not authenticated' do
      before do
        post :comments_create, params: { id: 123 }
      end

      include_examples 'user not authenticated'
    end
  end

  # loan action method tests
  describe 'POST #loan' do
    # when the use is logged
    context 'when the user is authenticated' do
      before do
        sign_in user
      end
      # when the book does not exists
      context 'when the book does not exists' do
        it 'raises Record NotFound error' do
          expect do
            post :loan, params: { id: 999_999 }
          end .to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      # when the book is not available
      context 'when the book is not available' do
        before do
          book.update_attribute('available', false)
          post :loan, params: { id: book.slug }
        end

        it 'send a book unavailable alert message' do
          expect(flash[:alert]).to eq('This book is not available, you can not borrow this')
        end

        it 'redirects to store book details page' do
          expect(response).to redirect_to(store_show_path(id: book.slug))
        end
      end

      # when the book is available
      context 'when the book is available' do
        before do
          post :loan, params: { id: book.slug }
        end

        it 'send a success notice message' do
          expect(flash[:notice]).to eq('You have successfully borrowed this book')
        end

        it 'redirects to store book details page' do
          expect(response).to redirect_to(store_show_path(id: book.slug))
        end
      end
    end
    # when the user is not yet logged
    context 'when the user is not authenticated' do
      before do
        post :loan, params: { id: 123 }
      end

      include_examples 'user not authenticated'
    end
  end

  # availability method tests
  describe 'GET #availability' do
    # when the use is logged
    context 'when the user is authenticated' do
      before do
        sign_in user
      end
      # when the book does not exists
      context 'when the book does not exists' do
        it 'raises Record NotFound error' do
          expect do
            get :availability, params: { id: 999_999 }
          end .to raise_error(ActiveRecord::RecordNotFound)
        end
      end
      # when the book exists
      context 'when the book exists' do
        before do
          FactoryBot.create(:book_loan, user: user, book: book, returned: false)
          get :availability, params: { id: book.slug }
        end

        it 'send a success notice message' do
          expect(flash[:notice]).to eq('An email has been sent to you about the current state of this book')
        end

        it 'redirects to store book details page' do
          expect(response).to redirect_to(store_show_path(id: book.slug))
        end
      end
    end
    # when the user is not yet logged
    context 'when the user is not authenticated' do
      before do
        get :availability, params: { id: 123 }
      end

      include_examples 'user not authenticated'
    end
  end
end
