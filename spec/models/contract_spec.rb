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
    described_class.current_versions_dataset.delete
    described_class.new
                   .update_attributes(start_date: Time.zone.today - 1, end_date: Time.zone.today + 1)
                   .update_attributes(legal: "King Size")
    versions = described_class.current_versions_dataset.all
    expect(versions.size).to eq(1)
    expect(versions[0].legal).to eq("King Size")
  end

  it "don't create any new version without change" do
    employee = described_class.new
    employee.update_attributes start_date: Time.zone.today - 1, end_date: Time.zone.today + 1
    employee.update_attributes end_date: Time.zone.today + 1
    employee.update_attributes start_date: Time.zone.today - 1, end_date: Time.zone.today + 1
    expect(employee).to have_versions %(
      | start_date | end_date   | created_at | expired_at | valid_from | valid_to | current |
      | 2009-11-27 | 2009-11-29 | 2009-11-28 |            | 2009-11-28 | MAX DATE | true    |
    )
  end
end
