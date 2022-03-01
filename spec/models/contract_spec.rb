require 'rails_helper'

RSpec.describe Contract, type: :model do
  let(:valid_attributes) do
    {
      start_date: '2022-03-01',
      end_date: '2022-03-02',
      legal: 'Legal'
    }
  end

  let(:invalid_attributes) do
    {
      start_date: '2022-03-01',
      end_date: '',
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
      end.to raise_error("end_date can't be blank")
    end

    it 'update a contract' do
      contract = described_class.create(valid_attributes)
      expect do
        contract.update(start_date: nil)
      end.to raise_error("start_date can't be blank")
    end
  end

  it 'destroy a contract' do
    contract = described_class.create(valid_attributes)
    expect do
      contract.delete
    end.to change(described_class, :count).by(-1)
  end
end
