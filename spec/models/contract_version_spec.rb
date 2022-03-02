require 'rails_helper'

RSpec.describe ContractVersion, type: :model do
  # rubocop:disable Layout/LineLength
  it "checks required columns are present" do
    expect do
      described_class.plugin :bitemporal, version_class: Contract
    end.to raise_error Sequel::Error, "bitemporal plugin requires the following missing columns on version class: master_id, valid_from, valid_to, created_at, expired_at"
  end
  # rubocop:enable Layout/LineLength
end
