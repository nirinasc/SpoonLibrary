require 'rails_helper'
# Category Model Tests Spec
RSpec.describe Category, type: :model do
  context 'Validation' do
    subject(:category) { FactoryBot.build(:category) }

    shared_examples 'unable to persist category' do
      it 'can not be persisted' do
        category.save
        expect(category).to_not be_persisted
      end
    end

    shared_examples 'able to persist category' do
      it 'can be persisted' do
        category.save
        expect(category).to be_persisted
      end
    end

    specify do
      expect(category).to be_an(Category)
    end

    context 'when all attributes are good' do
      include_examples 'able to persist category'
    end

    ## name attribute validation
    context 'when name is not present' do
      before do
        category.name = nil
        category.valid?
      end
      it 'get a name attribute missing error' do
        expect(category.errors.details[:name]).to include(error: :blank)
      end
      include_examples 'unable to persist category'
    end

    ## content attribute validation
    context 'when name length is lower than 2' do
      before do
        category.name = 'c'
        category.valid?
      end
      it 'get a name attribute length error' do
        expect(category.errors.details[:name]).to include(error: :too_short, count: 2)
      end
      include_examples 'unable to persist category'
    end

    ## When description is not present
    context 'when description is not present' do
      before do
        category.description = nil
      end
      include_examples 'able to persist category'
    end
  end
end
