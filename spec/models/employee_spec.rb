require 'rails_helper'

RSpec.describe Employee, type: :model do
  it "checks version class is given" do
    expect do
      described_class.plugin :bitemporal
    end.to raise_error Sequel::Error, "please specify version class to use for bitemporal plugin"
  end

  # it "defines current_versions_dataset" do
  #   described_class.new
  #                  .update_attributes(frist_name: "Single Standard")
  #                  .update_attributes(first_name: "King Size")
  #   versions = described_class.current_versions_dataset.all
  #   expect(versions.size).to eq(1)
  #   expect(versions[0].first_name).to eq("King Size")
  # end
end
