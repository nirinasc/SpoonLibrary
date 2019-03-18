require 'rails_helper'

# StoreController Controller Tests Spec
RSpec.describe StoreController, type: :controller do
  # create an authenticated user
  let(:user) { FactoryBot.create(:user, active: true) }
  # Fill in the db with 10 books
  let(:number_of_books) { 30 }

  before do
    # create 2 library
    libraries = []
    2.times do |index|
      libraries << FactoryBot.create(:library, name: "library-#{index}")
    end
    # create 3 categories first
    categories = []
    3.times do |index|
      categories << FactoryBot.create(:category, name: "category-#{index}")
    end

    # create number_of_books books
    number_of_books.times do |index|
      FactoryBot.create(
        :book,
        name: "book-#{index}",
        available: Faker::Boolean.boolean,
        library: index < number_of_books - 10 ? libraries[0] : libraries[1],
        categories: index < number_of_books - 4 ? [categories[Faker::Number.between(0, 1)]] : [categories[2]]
      )
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

  # index action method tests
  describe 'GET #index' do
    # when the user is logged
    context 'when the user is authenticated' do
      let(:libraries) { Library.all }
      let(:categories) { Category.all }
      let(:books) { Book.ransack.result.paginate(page: nil, per_page: 20).order(id: :desc) }

      before do
        sign_in user
        get :index
      end

      it 'assigns @libraries' do
        expect(assigns(:libraries)).to eq(libraries)
      end

      it 'assigns @categories' do
        expect(assigns(:categories)).to eq(categories)
      end

      it 'assigns @books' do
        expect(assigns(:books)).to eq(books)
      end

      it 'responds successfully' do
        expect(response).to have_http_status(200)
      end

      it 'render the index template' do
        expect(response).to render_template(:index)
      end
    end

    # when the user is not yet logged
    context 'when the user is not authenticated' do
      before do
        get :index
      end

      include_examples 'user not authenticated'
    end
  end

  # show action method tests
  describe 'GET #show' do
    # when the user is logged
    context 'when the user is authenticated' do
      before do
        sign_in user
      end

      # when the book id is not valid
      context 'when the book id is not valid' do
        it 'raise Record Not Found Error' do
          expect { get :show, params: { id: 999_999 } }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      # when the book id is valid
      context 'when the book id is valid' do
        before do
          get :show, params: { id: Book.last.slug }
        end
        it 'assigns @book' do
          expect(assigns(:book)).to eq(Book.last)
        end
        it 'responds successfully' do
          expect(response).to have_http_status(200)
        end
        it 'render the index template' do
          expect(response).to render_template(:show)
        end
      end
    end

    # when the user is not yet logged
    context 'when the user is not authenticated' do
      before do
        get :show, params: { id: Book.last.id }
      end

      include_examples 'user not authenticated'
    end
  end
end
