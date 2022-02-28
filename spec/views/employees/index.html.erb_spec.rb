require 'rails_helper'

RSpec.describe "employees/index", type: :view do
  before do
    assign(:employees, [
             Employee.create!(
               first_name: "First Name",
               last_name: "Last Name",
               address: "MyText"
             ),
             Employee.create!(
               first_name: "First Name",
               last_name: "Last Name",
               address: "MyText"
             )
           ])
  end

  it "renders a list of employees" do
    render
    assert_select "tr>td", text: "First Name".to_s, count: 2
    assert_select "tr>td", text: "Last Name".to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
  end
end
