require 'rails_helper'

RSpec.describe Contract, type: :model do
  before do
    Timecop.freeze 2009, 11, 28
  end

  after do
    Timecop.return
  end

  it "checks version class is given" do
    expect do
      described_class.plugin :bitemporal
    end.to raise_error Sequel::Error, "please specify version class to use for bitemporal plugin"
  end

  it "defines current_versions_dataset" do
    employee = Employee.create(first_name: 'First', last_name: 'Last')
    described_class.truncate
    ContractVersion.truncate
    contract = described_class.new(employee_id: employee.id)
    contract.update_attributes(start_date: Time.zone.today - 1, end_date: Time.zone.today + 1)
    contract.update_attributes(legal: 'King Size')
    versions = described_class.current_versions_dataset.all
    expect(versions.size).to eq(1)
    # validates_overlap
    # expect(versions[0].legal).to eq("King Size")
  end

  it "don't create any new version without change" do
    employee = Employee.create(first_name: 'First', last_name: 'Last')
    contract = described_class.new(employee_id: employee.id)
    contract.update_attributes start_date: Time.zone.today - 1, end_date: Time.zone.today + 1
    contract.update_attributes end_date: Time.zone.today + 1
    contract.update_attributes start_date: Time.zone.today - 1, end_date: Time.zone.today + 1
    expect(contract).to have_versions %(
      | start_date | end_date   | created_at | expired_at | valid_from | valid_to | current |
      | 2009-11-27 | 2009-11-29 | 2009-11-28 |            | 2009-11-28 | MAX DATE | true    |
    )
  end

  describe 'period overlap' do
    before do
      described_class.truncate
      ContractVersion.truncate
      @today = Time.zone.today
      @employee = Employee.create(first_name: 'First', last_name: 'Last')
      @contract = described_class.new(employee_id: @employee.id)
      # -3, 3
      @contract.update_attributes(start_date: @today - 3, end_date: @today + 3)
    end

    # complete overlap (-2,2)
    it "don't create new version by complete overlap" do
      expect(@contract.update_attributes(start_date: @today - 2, end_date: @today + 2)).to be_falsey
      errors = ["can't overlap with the period[#{@today - 2}..#{@today + 2}]"]
      expect(@contract.errors).to eq({ start_date: errors, end_date: errors })
    end

    # left overlap (0,4)
    it "don't create new version by left overlap" do
      expect(@contract.update_attributes(start_date: @today, end_date: @today + 4)).to be_falsey
      errors = ["can't overlap with the period[#{@today}..#{@today + 4}]"]
      expect(@contract.errors).to eq({ start_date: errors, end_date: errors })
    end

    # right overlap (-4,0)
    it "don't create new version by right overlap" do
      expect(@contract.update_attributes(start_date: @today - 4, end_date: @today)).to be_falsey
      errors = ["can't overlap with the period[#{@today - 4}..#{@today}]"]
      expect(@contract.errors).to eq({ start_date: errors, end_date: errors })
    end

    it "create new version by valid overlap" do
      # left valid (-5,4)
      expect(@contract.update_attributes(start_date: @today - 5, end_date: @today - 4)).to be_truthy
      expect(@contract.errors).to be_empty

      # right valid (4,5)
      expect(@contract.update_attributes(start_date: @today + 4, end_date: @today + 5)).to be_truthy
      expect(@contract.errors).to be_empty
    end
  end
end
