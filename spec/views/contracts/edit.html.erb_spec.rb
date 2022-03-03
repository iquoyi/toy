require 'rails_helper'

RSpec.describe "contracts/edit", type: :view do
  before do
    @employee = Employee.create(first_name: 'First', last_name: 'Last')
    @contract = Contract.new(employee_id: @employee.id)
    @contract.update_attributes(start_date: '2022-03-01', end_date: '2022-03-02', legal: "MyString")
  end

  it "renders the edit contract form" do
    render

    assert_select "form[action=?][method=?]", employee_contract_path(@employee.id, @contract.id), "post" do
      assert_select "input[name=_method][value=?]", "patch"

      assert_select "input[type=date][name=?]", "contract[start_date]"
      assert_select "input[type=date][value=?]", "2022-03-01"

      assert_select "input[type=date][name=?]", "contract[end_date]"
      assert_select "input[type=date][value=?]", "2022-03-02"

      assert_select "input[name=?]", "contract[legal]"
      assert_select "input[type=text][value=?]", "MyString"
    end
  end

  it 'renders include show link' do
    render
    expect(rendered).to include('Show')
    assert_select("a[href=?]", employee_contract_path(@employee.id, @contract.id))
  end

  it 'renders include back link' do
    render
    expect(rendered).to include('Back')
    assert_select("a[href=?]", employee_path(@employee.id))
  end
end
