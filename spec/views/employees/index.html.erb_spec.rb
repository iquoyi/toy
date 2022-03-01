require 'rails_helper'

RSpec.describe "employees/index", type: :view do
  before do
    @employee1 = Employee.new
    @employee1.update_attributes(first_name: "First Name 1", last_name: "Last Name 1", address: "Address 1")

    @employee2 = Employee.new
    @employee2.update_attributes(first_name: "First Name 2", last_name: "Last Name 2", address: "Address 2")

    @employees = [@employee1, @employee2]
  end

  it "renders a list of employees" do
    render
    expect(rendered).to include('First Name 1')
    expect(rendered).to include('Last Name 1')
    expect(rendered).to include('Address 1')
    expect(rendered).to include('First Name 2')
    expect(rendered).to include('Last Name 2')
    expect(rendered).to include('Address 2')
  end
end
