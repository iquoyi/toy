require 'rails_helper'

RSpec.describe "layouts/application.html.erb", type: :view do
  it "renders include navbar partial view" do
    render
    assert_select "body > nav .navbar-brand", text: "Toy"
  end

  it "renders include footer partial view" do
    render
    assert_select "body > footer p", text: "Copyright"
  end

  it "renders include breadcrumb partial view" do
    render
    assert_select "body > .container-fluid ol.breadcrumb", 'Home'
  end
end
