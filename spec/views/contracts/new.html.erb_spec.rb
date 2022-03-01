require 'rails_helper'

RSpec.describe "contracts/new", type: :view do
  before do
    assign(:contract, Contract.new(
                        start_date: '2022-03-01',
                        end_date: '2022-03-01',
                        legal: "MyString"
                      ))
  end

  it "renders new contract form" do
    render

    assert_select "form[action=?][method=?]", contracts_path, "post" do
      assert_select "input[type=date][name=?]", "contract[start_date]"
      assert_select "input[type=date][name=?]", "contract[end_date]"
      assert_select "input[name=?]", "contract[legal]"
    end
  end

  it 'renders include back link' do
    render
    expect(rendered).to include('Back')
    assert_select("a[href=?]", contracts_path)
  end
end
