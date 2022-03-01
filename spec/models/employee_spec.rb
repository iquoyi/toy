require 'rails_helper'

RSpec.describe Employee, type: :model do
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
                   .update_attributes(first_name: "Single Standard", last_name: "Standard Single")
                   .update_attributes(first_name: "King Size")
    versions = described_class.current_versions_dataset.all
    expect(versions.size).to eq(1)
    expect(versions[0].first_name).to eq("King Size")
  end

  it "propagates errors from version to employee" do
    employee = described_class.new
    expect(employee).to be_valid
    employee.attributes = { first_name: "Single Standard" }
    expect(employee).not_to be_valid
    expect(employee.errors).to eq({ last_name: ["can't be empty"] })
  end

  it "#update_attributes returns false instead of raising errors" do
    employee = described_class.new
    expect(employee.update_attributes(first_name: "Single Standard")).to be_falsey
    expect(employee).to be_new
    expect(employee.errors).to eq({ last_name: ["can't be empty"] })
    expect(employee.update_attributes(last_name: "Standard Single")).to be_truthy
  end

  it "allows creating a employee and its first version in one step" do
    employee = described_class.new
    result = employee.update_attributes first_name: "Single", last_name: "Standard"
    expect(result).to be_truthy
    expect(result).to eq(employee)
    expect(employee).not_to be_new
    expect(employee).to have_versions %(
      | first_name | last_name | created_at | expired_at | valid_from | valid_to | current |
      | Single     | Standard  | 2009-11-28 |            | 2009-11-28 | MAX DATE | true    |
    )
  end

  it "allows creating a new version in the past" do
    employee = described_class.new
    employee.update_attributes first_name: "Single", last_name: "Standard", valid_from: Time.zone.today - 1
    expect(employee).to have_versions %(
      | first_name | last_name | created_at | expired_at | valid_from | valid_to | current |
      | Single     | Standard  | 2009-11-28 |            | 2009-11-27 | MAX DATE | true    |
    )
  end

  it "allows creating a new version in the future" do
    employee = described_class.new
    employee.update_attributes first_name: "Single", last_name: "Standard", valid_from: Time.zone.today + 1
    expect(employee).to have_versions %(
      | first_name | last_name | created_at | expired_at | valid_from | valid_to | current |
      | Single     | Standard  | 2009-11-28 |            | 2009-11-29 | MAX DATE |         |
    )
  end

  it "doesn't loose previous version in same-day update" do
    employee = described_class.new
    employee.update_attributes first_name: "Single", last_name: "Standard"
    employee.update_attributes first_name: "Single", last_name: "Standard Substitute"
    expect(employee).to have_versions %(
      | first_name | last_name           | created_at | expired_at | valid_from | valid_to | current |
      | Single     | Standard            | 2009-11-28 | 2009-11-28 | 2009-11-28 | MAX DATE |         |
      | Single     | Standard Substitute | 2009-11-28 |            | 2009-11-28 | MAX DATE | true    |
    )
  end

  it "allows partial updating based on current version" do
    employee = described_class.new
    employee.update_attributes first_name: "Single", last_name: "Standard"
    employee.update_attributes last_name: "Standard Substitute"
    employee.update_attributes first_name: "King Size"
    expect(employee).to have_versions %(
      | first_name | last_name           | created_at | expired_at | valid_from | valid_to | current |
      | Single     | Standard            | 2009-11-28 | 2009-11-28 | 2009-11-28 | MAX DATE |         |
      | Single     | Standard Substitute | 2009-11-28 | 2009-11-28 | 2009-11-28 | MAX DATE |         |
      | King Size  | Standard Substitute | 2009-11-28 |            | 2009-11-28 | MAX DATE | true    |
    )
  end

  it "expires previous version but keep it in history" do
    employee = described_class.new
    employee.update_attributes first_name: "Single", last_name: "Standard"
    Timecop.freeze Time.zone.today + 1
    employee.update_attributes last_name: "Standard Substitute"
    expect(employee).to have_versions %(
      | first_name | last_name           | created_at | expired_at | valid_from | valid_to   | current |
      | Single     | Standard            | 2009-11-28 | 2009-11-29 | 2009-11-28 | MAX DATE   |         |
      | Single     | Standard            | 2009-11-29 |            | 2009-11-28 | 2009-11-29 |         |
      | Single     | Standard Substitute | 2009-11-29 |            | 2009-11-29 | MAX DATE   | true    |
    )
  end

  it "doesn't expire no longer valid versions" do
    employee = described_class.new
    employee.update_attributes first_name: "Single", last_name: "Standard", valid_to: Time.zone.today + 1
    Timecop.freeze Time.zone.today + 1
    expect(employee.update_attributes(last_name: "Standard Substitute")).to be_falsey
    employee.update_attributes first_name: "Single", last_name: "Standard Substitute"
    expect(employee).to have_versions %(
      | first_name | last_name           | created_at | expired_at | valid_from | valid_to   | current |
      | Single     | Standard            | 2009-11-28 |            | 2009-11-28 | 2009-11-29 |         |
      | Single     | Standard Substitute | 2009-11-29 |            | 2009-11-29 | MAX DATE   | true    |
    )
  end

  it "allows shortening validity (SEE COMMENTS FOR IMPROVEMENTS)" do
    employee = described_class.new
    employee.update_attributes first_name: "Single", last_name: "Standard"
    Timecop.freeze Time.zone.today + 1
    employee.update_attributes valid_to: Time.zone.today + 10
    expect(employee).to have_versions %(
      | first_name | last_name | created_at | expired_at | valid_from | valid_to   | current |
      | Single     | Standard  | 2009-11-28 | 2009-11-29 | 2009-11-28 | MAX DATE   |         |
      | Single     | Standard  | 2009-11-29 |            | 2009-11-28 | 2009-11-29 |         |
      | Single     | Standard  | 2009-11-29 |            | 2009-11-29 | 2009-12-09 | true    |
    )
    # would be even better if it could be:
    # | name            | price | created_at | expired_at | valid_from | valid_to   | current |
    # | Single Standard | 98    | 2009-11-28 | 2009-11-29 | 2009-11-28 | 2009-11-30 |         |
    # | Single Standard | 98    | 2009-11-29 |            | 2009-11-28 | 2009-12-09 | true    |
  end

  it "allows extending validity (SEE COMMENTS FOR IMPROVEMENTS)" do
    employee = described_class.new
    employee.update_attributes first_name: "Single", last_name: "Standard", valid_to: Time.zone.today + 2
    Timecop.freeze Time.zone.today + 1
    expect(employee).to have_versions %(
      | first_name | last_name | created_at | expired_at | valid_from | valid_to   | current |
      | Single     | Standard  | 2009-11-28 |            | 2009-11-28 | 2009-11-30 | true    |
    )
    employee.update_attributes valid_to: nil
    expect(employee).to have_versions %(
      | first_name | last_name | created_at | expired_at | valid_from | valid_to   | current |
      | Single     | Standard  | 2009-11-28 | 2009-11-29 | 2009-11-28 | 2009-11-30 |         |
      | Single     | Standard  | 2009-11-29 |            | 2009-11-28 | 2009-11-29 |         |
      | Single     | Standard  | 2009-11-29 |            | 2009-11-29 | MAX DATE   | true    |
    )
    # would be even better if it could be:
    # | name            | price | created_at | expired_at | valid_from | valid_to   | current |
    # | Single Standard | 98    | 2009-11-28 | 2009-11-29 | 2009-11-28 | 2009-11-30 |         |
    # | Single Standard | 98    | 2009-11-29 |            | 2009-11-28 | MAX DATE   | true    |
  end

  it "don't create any new version without change" do
    employee = described_class.new
    employee.update_attributes first_name: "Single", last_name: "Standard"
    employee.update_attributes last_name: "Standard"
    employee.update_attributes first_name: "Single", last_name: "Standard"
    expect(employee).to have_versions %(
      | first_name | last_name | created_at | expired_at | valid_from | valid_to | current |
      | Single     | Standard  | 2009-11-28 |            | 2009-11-28 | MAX DATE | true    |
    )
  end

  it "change in validity still creates a new version (SEE COMMENTS FOR IMPROVEMENTS)" do
    employee = described_class.new
    employee.update_attributes first_name: "Single", last_name: "Standard"
    Timecop.freeze Time.zone.today + 1
    employee.update_attributes last_name: "Standard", valid_from: Time.zone.today - 2
    employee.update_attributes last_name: "Standard", valid_from: Time.zone.today + 1
    expect(employee).to have_versions %(
      | first_name | last_name | created_at | expired_at | valid_from | valid_to   | current |
      | Single     | Standard  | 2009-11-28 |            | 2009-11-28 | MAX DATE   | true    |
      | Single     | Standard  | 2009-11-29 |            | 2009-11-27 | 2009-11-28 |         |
    )
    # would be even better if it could be:
    # | name            | price | created_at | expired_at | valid_from | valid_to   | current |
    # | Single Standard | 98    | 2009-11-28 | 2009-11-29 | 2009-11-28 | MAX DATE   |         |
    # | Single Standard | 98    | 2009-11-29 |            | 2009-11-27 | MAX DATE   | true    |
  end

  it "overrides no future versions" do
    employee = described_class.new
    employee.update_attributes first_name: "Single", last_name: "Standard", valid_to: Time.zone.today + 2
    employee.update_attributes(first_name: "Single", last_name: "Standard 1",
                               valid_from: Time.zone.today + 2, valid_to: Time.zone.today + 4)
    employee.update_attributes(first_name: "Single", last_name: "Standard 2",
                               valid_from: Time.zone.today + 4, valid_to: Time.zone.today + 6)
    Timecop.freeze Time.zone.today + 1
    employee.update_attributes first_name: "King Size", valid_to: nil
    expect(employee).to have_versions %(
      | first_name | last_name  | created_at | expired_at | valid_from | valid_to   | current |
      | Single     | Standard   | 2009-11-28 | 2009-11-29 | 2009-11-28 | 2009-11-30 |         |
      | Single     | Standard 1 | 2009-11-28 |            | 2009-11-30 | 2009-12-02 |         |
      | Single     | Standard 2 | 2009-11-28 |            | 2009-12-02 | 2009-12-04 |         |
      | Single     | Standard   | 2009-11-29 |            | 2009-11-28 | 2009-11-29 |         |
      | King Size  | Standard   | 2009-11-29 |            | 2009-11-29 | 2009-11-30 | true    |
    )
  end

  it "overrides multiple future versions" do
    employee = described_class.new
    employee.update_attributes first_name: "Single", last_name: "Standard", valid_to: Time.zone.today + 2
    employee.update_attributes(first_name: "Single", last_name: "Standard 1",
                               valid_from: Time.zone.today + 2, valid_to: Time.zone.today + 4)
    employee.update_attributes(first_name: "Single", last_name: "Standard 2",
                               valid_from: Time.zone.today + 4, valid_to: Time.zone.today + 6)
    Timecop.freeze Time.zone.today + 1
    employee.update_attributes first_name: "King Size", valid_to: Time.zone.today + 4
    expect(employee).to have_versions %(
      | first_name | last_name  | created_at | expired_at | valid_from | valid_to   | current |
      | Single     | Standard   | 2009-11-28 | 2009-11-29 | 2009-11-28 | 2009-11-30 |         |
      | Single     | Standard 1 | 2009-11-28 | 2009-11-29 | 2009-11-30 | 2009-12-02 |         |
      | Single     | Standard 2 | 2009-11-28 | 2009-11-29 | 2009-12-02 | 2009-12-04 |         |
      | Single     | Standard   | 2009-11-29 |            | 2009-11-28 | 2009-11-29 |         |
      | Single     | Standard 2 | 2009-11-29 |            | 2009-12-03 | 2009-12-04 |         |
      | King Size  | Standard   | 2009-11-29 |            | 2009-11-29 | 2009-12-03 | true    |
    )
  end

  it "overrides all future versions" do
    employee = described_class.new
    employee.update_attributes first_name: "Single", last_name: "Standard", valid_to: Time.zone.today + 2
    employee.update_attributes(first_name: "Single", last_name: "Standard 1",
                               valid_from: Time.zone.today + 2, valid_to: Time.zone.today + 4)
    employee.update_attributes(first_name: "Single", last_name: "Standard 2",
                               valid_from: Time.zone.today + 4, valid_to: Time.zone.today + 6)
    Timecop.freeze Time.zone.today + 1
    employee.update_attributes first_name: "King Size", valid_to: Time.utc(9999)
    expect(employee).to have_versions %(
      | first_name | last_name  | created_at | expired_at | valid_from | valid_to   | current |
      | Single     | Standard   | 2009-11-28 | 2009-11-29 | 2009-11-28 | 2009-11-30 |         |
      | Single     | Standard 1 | 2009-11-28 | 2009-11-29 | 2009-11-30 | 2009-12-02 |         |
      | Single     | Standard 2 | 2009-11-28 | 2009-11-29 | 2009-12-02 | 2009-12-04 |         |
      | Single     | Standard   | 2009-11-29 |            | 2009-11-28 | 2009-11-29 |         |
      | King Size  | Standard   | 2009-11-29 |            | 2009-11-29 | MAX DATE   | true    |
    )
  end

  it "allows deleting current version" do
    employee = described_class.new
    employee.update_attributes(first_name: "Single", last_name: "Standard 1",
                               valid_from: Time.zone.today - 2, valid_to: Time.zone.today)
    employee.update_attributes first_name: "Single", last_name: "Standard"
    employee.update_attributes first_name: "Single", last_name: "Standard 2", valid_from: Time.zone.today + 2
    Timecop.freeze Time.zone.today + 1
    expect(employee.current_version.destroy).to be_truthy
    expect(employee).to have_versions %(
      | first_name | last_name  | created_at | expired_at | valid_from | valid_to   | current |
      | Single     | Standard 1 | 2009-11-28 |            | 2009-11-26 | 2009-11-28 |         |
      | Single     | Standard   | 2009-11-28 | 2009-11-28 | 2009-11-28 | MAX DATE   |         |
      | Single     | Standard   | 2009-11-28 | 2009-11-29 | 2009-11-28 | 2009-11-30 |         |
      | Single     | Standard 2 | 2009-11-28 |            | 2009-11-30 | MAX DATE   |         |
      | Single     | Standard   | 2009-11-29 |            | 2009-11-28 | 2009-11-29 |         |
    )
    expect(employee).to be_deleted
  end

  it "allows deleting current version to restore the previous one" do
    employee = described_class.new
    employee.update_attributes(first_name: "Single", last_name: "Standard 1",
                               valid_from: Time.zone.today - 2, valid_to: Time.zone.today)
    employee.update_attributes first_name: "Single", last_name: "Standard"
    employee.update_attributes first_name: "Single", last_name: "Standard 2", valid_from: Time.zone.today + 2
    Timecop.freeze Time.zone.today + 1
    expect(employee.current_version.destroy(expand_previous_version: true)).to be_truthy
    expect(employee).to have_versions %(
      | first_name | last_name  | created_at | expired_at | valid_from | valid_to   | current |
      | Single     | Standard 1 | 2009-11-28 |            | 2009-11-26 | 2009-11-28 |         |
      | Single     | Standard   | 2009-11-28 | 2009-11-28 | 2009-11-28 | MAX DATE   |         |
      | Single     | Standard   | 2009-11-28 | 2009-11-29 | 2009-11-28 | 2009-11-30 |         |
      | Single     | Standard 2 | 2009-11-28 |            | 2009-11-30 | MAX DATE   |         |
      | Single     | Standard 1 | 2009-11-29 |            | 2009-11-29 | 2009-11-30 | true    |
      | Single     | Standard   | 2009-11-29 |            | 2009-11-28 | 2009-11-29 |         |
    )
  end

  it "allows deleting a future version" do
    employee = described_class.new
    employee.update_attributes first_name: "Single", last_name: "Standard"
    employee.update_attributes first_name: "Single", last_name: "Standard 1", valid_from: Time.zone.today + 2
    Timecop.freeze Time.zone.today + 1
    expect(employee.versions.last.destroy).to be_truthy
    expect(employee).to have_versions %(
      | first_name | last_name  | created_at | expired_at | valid_from | valid_to   | current |
      | Single     | Standard   | 2009-11-28 | 2009-11-28 | 2009-11-28 | MAX DATE   |         |
      | Single     | Standard   | 2009-11-28 | 2009-11-29 | 2009-11-28 | 2009-11-30 |         |
      | Single     | Standard 1 | 2009-11-28 | 2009-11-29 | 2009-11-30 | MAX DATE   |         |
      | Single     | Standard   | 2009-11-29 |            | 2009-11-28 | MAX DATE   | true    |
    )
  end

  it "allows deleting a future version without expanding the current one" do
    employee = described_class.new
    employee.update_attributes first_name: "Single", last_name: "Standard"
    employee.update_attributes first_name: "Single", last_name: "Standard 1", valid_from: Time.zone.today + 2
    Timecop.freeze Time.zone.today + 1
    expect(employee.versions.last.destroy(expand_previous_version: false)).to be_truthy
    expect(employee).to have_versions %(
      | first_name | last_name  | created_at | expired_at | valid_from | valid_to   | current |
      | Single     | Standard   | 2009-11-28 | 2009-11-28 | 2009-11-28 | MAX DATE   |         |
      | Single     | Standard   | 2009-11-28 |            | 2009-11-28 | 2009-11-30 | true    |
      | Single     | Standard 1 | 2009-11-28 | 2009-11-29 | 2009-11-30 | MAX DATE   |         |
    )
  end

  it "allows deleting all versions" do
    employee = described_class.new
    employee.update_attributes first_name: "Single", last_name: "Standard"
    employee.update_attributes first_name: "Single", last_name: "Standard 1", valid_from: Time.zone.today + 2
    Timecop.freeze Time.zone.today + 1
    expect(employee.destroy).to be_truthy
    expect(employee).to have_versions %(
      | first_name | last_name  | created_at | expired_at | valid_from | valid_to   | current |
      | Single     | Standard   | 2009-11-28 | 2009-11-28 | 2009-11-28 | MAX DATE   |         |
      | Single     | Standard   | 2009-11-28 | 2009-11-29 | 2009-11-28 | 2009-11-30 |         |
      | Single     | Standard 1 | 2009-11-28 | 2009-11-29 | 2009-11-30 | MAX DATE   |         |
    )
  end

  it "allows simultaneous updates without information loss" do
    employee = described_class.new
    employee.update_attributes first_name: "Single", last_name: "Standard"
    Timecop.freeze Time.zone.today + 1
    employee2 = described_class.find id: employee.id
    employee.update_attributes first_name: "Single", last_name: "Standard 1"
    employee2.update_attributes first_name: "Single", last_name: "Standard 2"
    expect(employee).to have_versions %(
      | first_name | last_name  | created_at | expired_at | valid_from | valid_to   | current |
      | Single     | Standard   | 2009-11-28 | 2009-11-29 | 2009-11-28 | MAX DATE   |         |
      | Single     | Standard   | 2009-11-29 |            | 2009-11-28 | 2009-11-29 |         |
      | Single     | Standard 1 | 2009-11-29 | 2009-11-29 | 2009-11-29 | MAX DATE   |         |
      | Single     | Standard 2 | 2009-11-29 |            | 2009-11-29 | MAX DATE   | true    |
    )
  end

  it "allows simultaneous cumulative updates" do
    employee = described_class.new
    employee.update_attributes first_name: "Single", last_name: "Standard"
    Timecop.freeze Time.zone.today + 1
    employee2 = described_class.find id: employee.id
    employee.update_attributes last_name: "Standard 1"
    employee2.update_attributes first_name: "King Size"
    expect(employee).to have_versions %(
      | first_name | last_name  | created_at | expired_at | valid_from | valid_to   | current |
      | Single     | Standard   | 2009-11-28 | 2009-11-29 | 2009-11-28 | MAX DATE   |         |
      | Single     | Standard   | 2009-11-29 |            | 2009-11-28 | 2009-11-29 |         |
      | Single     | Standard 1 | 2009-11-29 | 2009-11-29 | 2009-11-29 | MAX DATE   |         |
      | King Size  | Standard 1 | 2009-11-29 |            | 2009-11-29 | MAX DATE   | true    |
    )
  end

  it "can expire invalid versions" do
    employee = described_class.new.update_attributes first_name: "Single", last_name: "Standard"
    employee.current_version.last_name = nil
    expect(employee.current_version).not_to be_valid
    employee.current_version.save validate: false
    Timecop.freeze Time.zone.today + 1
    employee.update_attributes last_name: "Standard 1"
    expect(employee).to have_versions %(
      | first_name | last_name  | created_at | expired_at | valid_from | valid_to   | current |
      | Single     |            | 2009-11-28 | 2009-11-29 | 2009-11-28 | MAX DATE   |         |
      | Single     |            | 2009-11-29 |            | 2009-11-28 | 2009-11-29 |         |
      | Single     | Standard 1 | 2009-11-29 |            | 2009-11-29 | MAX DATE   | true    |
    )
  end
  # https://github.com/TalentBox/sequel_bitemporal/blob/6c1b07b725e10a0e27d55d5f0c1790f90c225685/spec/bitemporal_date_spec.rb#L347
end
