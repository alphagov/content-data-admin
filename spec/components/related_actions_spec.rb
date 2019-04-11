require 'rails_helper'

RSpec.describe "Related actions", type: :view do
  let(:data) {
    {
      links: [
                {
                  link_url: "//www.gov.uk/govpage",
                  label: "View on GOV.UK"
                },
                {
                  link_url: "//www.gov.uk/moregov",
                  label: "Edit in Whitehall"
                }
              ]
      }
  }

  it "does not render when no data is passed" do
    assert_empty render_component({})
  end

  it "renders supplied links correctly" do
    render_component(data)
  end

  it "renders correctly when given valid data" do
    render_component(data)
    assert_select ".app-c-related-actions", 1
    assert_select "ul", 1
    assert_select "li", 2
    assert_select "a", href: "//www.gov.uk/govpage", text: "View on GOV.UK"
    assert_select "a", href: "//www.gov.uk/moregov", text: "Edit in Whitehall"
  end

  def render_component(locals)
    render partial: "components/related-actions", locals: locals
  end
end
