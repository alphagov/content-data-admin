require 'rails_helper'

RSpec.describe "Metadata", type: :view do
  let(:data) {
    {
        status: "withdrawn",
        published_at: "1 September 2016",
        last_updated: "1 October 2017",
        publishing_organisation: "UK Visas and Immigration",
        document_type: "Guidance",
        base_path: "/government/publications/visitor-visa-guide-to-supporting-documents",
    }
  }

  it "renders correctly when given valid data" do
    render_component(data)
    assert_select ".app-c-metadata"
    assert_select ".app-c-metadata__title", 6
    assert_select ".app-c-metadata__title", text: t("components.metadata.labels.status")
    assert_select ".app-c-metadata__description", text: "withdrawn"
    assert_select ".app-c-metadata__title", text: t("components.metadata.labels.published_at")
    assert_select ".app-c-metadata__description", text: "1 September 2016"
    assert_select ".app-c-metadata__title", text: t("components.metadata.labels.last_updated")
    assert_select ".app-c-metadata__description", text: "1 October 2017"
    assert_select ".app-c-metadata__title", text: t("components.metadata.labels.publishing_organisation")
    assert_select ".app-c-metadata__description", text: "UK Visas and Immigration"
    assert_select ".app-c-metadata__title", text: t("components.metadata.labels.document_type")
    assert_select ".app-c-metadata__description", text: "Guidance"
    assert_select ".app-c-metadata__title", text: t("components.metadata.labels.base_path")
    assert_select ".app-c-metadata__description", text: "gov.uk/government/publications/visitor-visa-guide-to-supporting-documents"
  end

  it "renders blank values for expected fields when data items aren't provided" do
    data = false
    render_component(data)
    assert_select ".app-c-metadata__description", text: "", count: 5
  end

  it "does not render status info when a status is not supplied" do
    data[:status] = false
    render_component(data)
    assert_select ".app-c-metadata__title", text: "Status", count: 0
  end

  def render_component(locals)
    render partial: "components/metadata", locals: locals
  end
end
