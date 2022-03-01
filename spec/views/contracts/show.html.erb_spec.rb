require 'rails_helper'

RSpec.describe "contracts/show", type: :view do
  before do
    @contract = assign(:contract, Contract.create(
                                    start_date: '2022-03-01',
                                    end_date: '2022-03-02',
                                    legal: "Legal"
                                  ))
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
    assert_select("a[href=?]", edit_contract_path(@contract.id))
  end

  it 'renders include back link' do
    render
    expect(rendered).to include('Back')
    assert_select("a[href=?]", contracts_path)
  end
end
