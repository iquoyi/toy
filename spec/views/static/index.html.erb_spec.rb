require 'rails_helper'

RSpec.describe "static/index.html.erb", type: :view do
  it "renders a list of employees" do
    render
    assert_select "p", text: "Find me in app/views/static/index.html.erb"
  end
end
