require 'rails_helper'

RSpec.describe "Related actions", type: :view do
  let(:data) {
    {
      links: [
                {
                  header: "View the page on GOV.UK",
                  link_url: "//www.gov.uk/govpage",
                  link_text: "Visit Govpage"
                },
                {
                  header: "Make changes to the page",
                  link_url: "//www.gov.uk/moregov",
                  link_text: "Visit More gov"
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
    assert_select "dl", 1
    assert_select "dt", 2
    assert_select "dd", 2
    assert_select ".app-c-related-actions__header", text: "View the page on GOV.UK"
    assert_select ".app-c-related-actions__header", text: "Make changes to the page"
    assert_select "a", href: "//www.gov.uk/govpage", text: "Visit Govpage"
    assert_select "a", href: "//www.gov.uk/moregov", text: "Visit More gov"
  end

  def render_component(locals)
    render partial: "components/related-actions", locals: locals
  end
end
