require 'rails_helper'

RSpec.describe "employees/edit", type: :view do
  before do
    @employee = assign(:employee, Employee.create!(
                                    first_name: "MyString",
                                    last_name: "MyString",
                                    address: "MyText"
                                  ))
  end

  it "renders the edit employee form" do
    render

    assert_select "form[action=?][method=?]", employee_path(@employee), "post" do
      assert_select "input[name=?]", "employee[first_name]"

      assert_select "input[name=?]", "employee[last_name]"

      assert_select "textarea[name=?]", "employee[address]"
    end
  end
end
