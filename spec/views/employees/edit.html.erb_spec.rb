require 'rails_helper'

RSpec.describe "employees/edit", type: :view do
  before do
    @employee = assign(:employee, Employee.create(
                                    first_name: "First Name",
                                    last_name: "Last Name",
                                    address: "Address"
                                  ))
  end

  it "renders the edit employee form" do
    render

    assert_select "form[action=?][method=?]", employee_path(@employee.id), "post" do
      assert_select "input[name=_method][value=?]", "patch"

      assert_select "input[name=?]", "employee[first_name]"
      assert_select "input[value=?]", "First Name"

      assert_select "input[name=?]", "employee[last_name]"
      assert_select "input[value=?]", "Last Name"

      assert_select "textarea[name=?]", "employee[address]"
      assert_select "textarea", "Address"
    end
  end
end
