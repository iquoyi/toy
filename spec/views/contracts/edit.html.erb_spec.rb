require 'rails_helper'

RSpec.describe "contracts/edit", type: :view do
  before do
    @contract = assign(:contract, Contract.create!(
                                    legal: "MyString"
                                  ))
  end

  it "renders the edit contract form" do
    render

    assert_select "form[action=?][method=?]", contract_path(@contract), "post" do
      assert_select "input[name=?]", "contract[legal]"
    end
  end
end
