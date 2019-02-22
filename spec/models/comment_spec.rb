require 'rails_helper'

RSpec.describe Comment, type: :model do

  let(:comment) { FactoryBot.build(:comment, user: FactoryBot.create(:user), book: FactoryBot.create(:book, library: FactoryBot.create(:library))) }

  shared_examples 'unable to persist comment' do
    it 'can not be persisted' do 
      comment.save
      expect(comment).to_not be_persisted
    end
  end
  
  shared_examples 'able to persist comment' do
    it 'can be persisted' do 
      comment.save
      expect(comment).to be_persisted
    end
  end

  specify do
    expect(comment).to be_an(Comment)
  end

  context 'when all attributes are good' do
    include_examples 'able to persist comment'
  end 

  ## user attribute validation
  context 'when user is not associated' do
     before do
      comment.user = nil
      comment.valid?
     end 
     it 'get a user attribute missing error' do
      expect(comment.errors.details[:user]).to include({:error=>:blank})
     end
     include_examples 'unable to persist comment'
  end

  ## book attribute validation
  context 'when book is not associated' do
    before do
     comment.book = nil
     comment.valid?
    end 
    it 'get a book attribute missing error' do
     expect(comment.errors.details[:book]).to include({:error=>:blank})
    end
    include_examples 'unable to persist comment'
  end

  ## content attribute validation
  context 'when content is not present' do
    before do
     comment.content = nil
     comment.valid?
    end 
    it 'get a content attribute missing error' do
     expect(comment.errors.details[:content]).to include({:error=>:blank})
    end
    include_examples 'unable to persist comment'
  end

  ## content attribute validation
  context 'when content length is lower than 2' do
    before do
      comment.content = 'c'
      comment.valid?
    end 
    it 'get a content attribute length error' do
      expect(comment.errors.details[:content]).to include({:error => :too_short, :count=>2})
    end
    include_examples 'unable to persist comment'
  end

end
