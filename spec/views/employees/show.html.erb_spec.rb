require 'rails_helper'

RSpec.describe "employees/show", type: :view do
  before do
    @employee = assign(:employee, Employee.create(
                                    first_name: "First Name",
                                    last_name: "Last Name",
                                    address: "MyText"
                                  ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/First Name/)
    expect(rendered).to match(/Last Name/)
    expect(rendered).to match(/MyText/)
  end

  it 'renders include links' do
    render
    expect(rendered).to include('Edit')
    expect(rendered).to include('Back')
  end
end
