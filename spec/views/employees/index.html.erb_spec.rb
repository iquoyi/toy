require 'rails_helper'

RSpec.describe "employees/index", type: :view do
  before do
    assign(:employees, [
             Employee.create(
               first_name: "First Name 1",
               last_name: "Last Name 1",
               address: "MyText 1"
             ),
             Employee.create(
               first_name: "First Name 2",
               last_name: "Last Name 2",
               address: "MyText 2"
             )
           ])
  end

  it "renders a list of employees" do
    render
    expect(rendered).to include('First Name 1')
    expect(rendered).to include('Last Name 1')
    expect(rendered).to include('MyText 1')
    expect(rendered).to include('First Name 2')
    expect(rendered).to include('Last Name 2')
    expect(rendered).to include('MyText 2')
  end

  it 'renders include new link' do
    render
    expect(rendered).to include('New Employee')
  end
end
