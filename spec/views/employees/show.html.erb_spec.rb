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

  # it 'renders include links' do
  #   render
  #   expect(rendered).to include('Edit')
  #   expect(rendered).to include('Back')
  # end
end
