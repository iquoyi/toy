require 'rails_helper'

RSpec.describe "contracts/index", type: :view do
  before do
    assign(:contracts, [
             Contract.create!(
               legal: "Legal"
             ),
             Contract.create!(
               legal: "Legal"
             )
           ])
  end

  it "renders a list of contracts" do
    render
    assert_select "tr>td", text: "Legal".to_s, count: 2
  end
end
