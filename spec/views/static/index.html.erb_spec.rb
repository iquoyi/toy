require 'rails_helper'

RSpec.describe "static/index.html.erb", type: :view do
  it "renders a static page" do
    render
    assert_select "p", text: "Find me in app/views/static/index.html.erb"
  end

  it "renders included employee nav link" do
    render
    assert_select "a", href: "/employees"
  end
end
