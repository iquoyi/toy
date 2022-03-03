require 'rails_helper'

RSpec.describe "employees/show", type: :view do
  before do
    @employee = Employee.new
    @employee.update_attributes(first_name: "First Name", last_name: "Last Name", address: "Address")
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/First Name/)
    expect(rendered).to match(/Last Name/)
    expect(rendered).to match(/Address/)
  end

  it 'renders the filter form' do
    render

    assert_select "form[action=?][method=?]", employee_path(@employee.id), "get" do
      assert_select "input[type=date][name=?]", "validity"
      # assert_select "input[name=validity]" do
      #   assert_select "[value=#{Time.zone.today}]", 1
      # end
      # assert_select "[name=validity][value=?]", Time.zone.today
      # assert_select "[name=validity][value=?]", Time.zone.today.strftime('%Y-%m-%d')
      # assert_select "[name=validity][value=#{Time.zone.today}]"
    end
  end
end
