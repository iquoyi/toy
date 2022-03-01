require 'rails_helper'

RSpec.describe "employees/new", type: :view do
  before do
    assign(:employee, Employee.new(
                        first_name: "MyString",
                        last_name: "MyString",
                        address: "MyText"
                      ))
  end

  it "renders new employee form" do
    render

    assert_select "h1", "New Employee"

    assert_select "form[action=?][method=?]", employees_path, "post" do
      assert_select "input[name=?]", "employee[first_name]"

      assert_select "input[name=?]", "employee[last_name]"

      assert_select "textarea[name=?]", "employee[address]"
    end
  end
end
