require 'rails_helper'

RSpec.describe EmployeeVersion, type: :model do
  describe 'normal test' do
    let(:valid_attributes) do
      {
        first_name: 'First Name',
        last_name: 'Last Name',
        birthday: '2022-03-01',
        address: 'Address'
      }
    end

    let(:invalid_attributes) do
      {
        first_name: '',
        last_name: 'Last Name',
        birthday: '2022-03-01',
        address: 'Address'
      }
    end

    context 'with valid parameters' do
      it 'create a employee' do
        expect do
          described_class.create(valid_attributes)
        end.to change(described_class, :count).by(1)
      end

      it 'update a employee' do
        employee = described_class.create(valid_attributes)
        employee.update(address: 'New Address')
        employee.reload
        expect(employee.address).to eq('New Address')
      end
    end

    context 'with invalid parameters' do
      it 'create a employee' do
        expect do
          described_class.create(invalid_attributes)
        end.to raise_error("first_name can't be empty")
      end

      it 'update a employee' do
        employee = described_class.create(valid_attributes)
        expect do
          employee.update(last_name: nil)
        end.to raise_error("last_name can't be empty")
      end
    end

    it 'destroy a employee' do
      employee = described_class.create(valid_attributes)
      expect do
        employee.delete
      end.to change(described_class, :count).by(-1)
    end
  end

  # rubocop:disable Layout/LineLength
  it "checks required columns are present" do
    expect do
      described_class.plugin :bitemporal, version_class: Employee
    end.to raise_error Sequel::Error, "bitemporal plugin requires the following missing columns on version class: master_id, valid_from, valid_to, created_at, expired_at"
  end
  # rubocop:enable Layout/LineLength
end
