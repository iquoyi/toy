require 'rails_helper'

RSpec.describe "contracts/index", type: :view do
  before do
    @contract1 = Contract.new
    @contract1.update_attributes(start_date: "2022-03-01", end_date: "2022-03-01", legal: "Legal_1")

    @contract2 = Contract.new
    @contract2.update_attributes(start_date: "2022-03-01", end_date: "2022-03-01", legal: "Legal_2")

    @contracts = [@contract1, @contract2]
  end

  it "renders a list of contracts" do
    render
    assert_select "tr>td", text: "Legal_1"
    assert_select "tr>td", text: "Legal_2"
  end
end
