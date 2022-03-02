require 'rails_helper'

RSpec.describe ContractVersion, type: :model do
  describe 'normal test' do
    let(:valid_attributes) do
      {
        start_date: '2022-03-01',
        end_date: '2022-03-01',
        legal: 'Legal'
      }
    end

    let(:invalid_attributes) do
      {
        start_date: '',
        end_date: '2022-03-01',
        legal: 'Legal'
      }
    end

    context 'with valid parameters' do
      it 'create a contract' do
        expect do
          described_class.create(valid_attributes)
        end.to change(described_class, :count).by(1)
      end

      it 'update a contract' do
        contract = described_class.create(valid_attributes)
        contract.update(legal: 'New Legal')
        contract.reload
        expect(contract.legal).to eq('New Legal')
      end
    end

    context 'with invalid parameters' do
      it 'create a contract' do
        expect do
          described_class.create(invalid_attributes)
        end.to raise_error("start_date is not present")
      end

      it 'update a contract' do
        contract = described_class.create(valid_attributes)
        expect do
          contract.update(start_date: nil)
        end.to raise_error("start_date is not present")
      end
    end

    it 'destroy a contract' do
      contract = described_class.create(valid_attributes)
      expect do
        contract.delete
      end.to change(described_class, :count).by(-1)
    end
  end

  # rubocop:disable Layout/LineLength
  it "checks required columns are present" do
    expect do
      described_class.plugin :bitemporal, version_class: Contract
    end.to raise_error Sequel::Error, "bitemporal plugin requires the following missing columns on version class: master_id, valid_from, valid_to, created_at, expired_at"
  end
  # rubocop:enable Layout/LineLength
end
