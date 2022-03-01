require 'rails_helper'

RSpec.describe "contracts/show", type: :view do
  before do
    @contract = assign(:contract, Contract.create!(
                                    legal: "Legal"
                                  ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Legal/)
  end
end
