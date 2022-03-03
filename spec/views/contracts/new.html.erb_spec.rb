require 'rails_helper'

RSpec.describe "contracts/new", type: :view do
  before do
    @employee = Employee.create(first_name: 'First', last_name: 'Last')
    @contract = Contract.new(employee_id: @employee.id)
  end

  it "renders new contract form" do
    render

    assert_select "form[action=?][method=?]", employee_contracts_path(@employee.id), "post" do
      assert_select "input[type=date][name=?]", "contract[start_date]"
      assert_select "input[type=date][name=?]", "contract[end_date]"
      assert_select "input[name=?]", "contract[legal]"
    end
  end

  # it 'renders include back link' do
  #   render
  #   expect(rendered).to include('Back')
  #   assert_select("a[href=?]", employee_path(@employee.id))
  # end
end
