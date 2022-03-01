require 'rails_helper'

RSpec.describe "contracts/index", type: :view do
  before do
    assign(:contracts, [
             Contract.create(
               start_date: '2022-03-01',
               end_date: '2022-03-01',
               legal: "Legal_1"
             ),
             Contract.create(
               start_date: '2022-03-01',
               end_date: '2022-03-01',
               legal: "Legal_2"
             )
           ])
  end

  it "renders a list of contracts" do
    render
    assert_select "tr>td", text: "Legal_1"
    assert_select "tr>td", text: "Legal_2"
  end
end
