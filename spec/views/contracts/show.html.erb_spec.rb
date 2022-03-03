require 'rails_helper'

RSpec.describe "contracts/show", type: :view do
  before do
    @employee = Employee.create(first_name: 'First', last_name: 'Last')
    @contract = Contract.new(employee_id: @employee.id)
    @contract.update_attributes(start_date: '2022-03-01', end_date: '2022-03-02', legal: "MyString")
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2022-03-01/)
    expect(rendered).to match(/2022-03-02/)
    expect(rendered).to match(/Legal/)
  end

  it 'renders include edit link' do
    render
    expect(rendered).to include('Edit')
    assert_select("a[href=?]", edit_employee_contract_path(@employee.id, @contract.id))
  end

  it 'renders include back link' do
    render
    expect(rendered).to include('Back')
    assert_select("a[href=?]", employee_path(@employee.id))
  end
end
