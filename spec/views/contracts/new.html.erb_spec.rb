require 'rails_helper'

RSpec.describe "contracts/new", type: :view do
  before do
    assign(:contract, Contract.new(
                        legal: "MyString"
                      ))
  end

  it "renders new contract form" do
    render

    assert_select "form[action=?][method=?]", contracts_path, "post" do
      assert_select "input[name=?]", "contract[legal]"
    end
  end
end
