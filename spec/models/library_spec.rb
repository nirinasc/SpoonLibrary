require 'rails_helper'
# Library Model Tests Spec
RSpec.describe Library, type: :model do
  context 'Validation' do
    subject(:library) { FactoryBot.build(:library) }

    shared_examples 'unable to persist library' do
      it 'can not be persisted' do
        library.save
        expect(library).to_not be_persisted
      end
    end

    shared_examples 'able to persist library' do
      it 'can be persisted' do
        library.save
        expect(library).to be_persisted
      end
    end

    specify do
      expect(library).to be_an(Library)
    end

    context 'when all attributes are good' do
      include_examples 'able to persist library'
    end

    context 'when name is not present' do
      before do
        library.name = nil
        library.valid?
      end

      it 'get a name attribute error' do
        expect(library.errors.details[:name]).to include(error: :blank)
      end

      include_examples 'unable to persist library'
    end

    context 'when country_code is not present' do
      before do
        library.country_code = nil
        library.valid?
      end

      it 'get a country_code attribute error' do
        expect(library.errors.details[:country_code]).to include(error: :blank)
      end

      include_examples 'unable to persist library'
    end

    context 'when country_code value is not valid' do
      before do
        library.country_code = 'NOTVALIDCODE'
        library.valid?
      end
      it 'get country_code not valid error' do
        expect(library.errors.details[:country_code]).to include(error: :inclusion, value: 'NOTVALIDCODE')
      end
      include_examples 'unable to persist library'
    end

    context 'when city is not present' do
      before do
        library.city = nil
        library.valid?
      end

      it 'get a city attribute error' do
        expect(library.errors.details[:city]).to include(error: :blank)
      end

      include_examples 'unable to persist library'
    end

    context 'when address is not present' do
      before do
        library.address = nil
        library.valid?
      end

      it 'get address attribute error' do
        expect(library.errors.details[:address]).to include(error: :blank)
      end

      include_examples 'unable to persist library'
    end

    ## When zip_code is not present
    context 'when country_code is not present' do
      before do
        library.zip_code = nil
      end
      include_examples 'able to persist library'
    end

    ## When phone is not present
    context 'when phone is not present' do
      before do
        library.phone = nil
      end
      include_examples 'able to persist library'
    end
  end
end
