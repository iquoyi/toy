require 'rails_helper'

RSpec.describe EmployeeVersion, type: :model do
  it "checks required columns are present" do
    expect do
      described_class.plugin :bitemporal, version_class: Employee
    end.to raise_error Sequel::Error, "bitemporal plugin requires the following missing columns \
                                      on version class: master_id, valid_from, valid_to, created_at, expired_at"
  end
end
