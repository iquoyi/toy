require 'rails_helper'

RSpec.describe "contracts/index", type: :view do
  before do
    @employee = Employee.create(first_name: 'First', last_name: 'Last')
    @contract1 = Contract.new(employee_id: @employee.id)
    @contract1.update_attributes(start_date: "2022-03-01", end_date: "2022-03-01", legal: "Legal_1")

    @contract2 = Contract.new(employee_id: @employee.id)
    @contract2.update_attributes(start_date: "2022-03-02", end_date: "2022-03-02", legal: "Legal_2")

    @contracts = [@contract1, @contract2]
  end

  it "renders a list of contracts" do
    # assign will sets @employee = Employee.new in the view template
    # assign(:employee, @employee)
    # assign(:contracts, @contracts)

    render
    assert_select "tr>td", text: "Legal_1"
    assert_select "tr>td", text: "Legal_2"
  end
end
