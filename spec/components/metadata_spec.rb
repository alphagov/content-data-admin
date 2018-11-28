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
    assert_select ".app-c-metadata__title", 4
    assert_select ".app-c-metadata__title", text: t("components.metadata.labels.status")
    assert_select ".app-c-metadata__description", text: "withdrawn"
    assert_select ".app-c-metadata__title", text: t("components.metadata.labels.publishing_organisation")
    assert_select ".app-c-metadata__description", text: "UK Visas and Immigration"
    assert_select ".app-c-metadata__title", text: t("components.metadata.labels.document_type")
    assert_select ".app-c-metadata__description", text: "Guidance"
    assert_select ".app-c-metadata__title", text: t("components.metadata.labels.base_path")
    assert_select ".app-c-metadata__description", text: "gov.uk/government/publications/visitor-visa-guide-to-supporting-documents"
  end

  it "does not render the 'status' fields when data is not supplied" do
    data[:status] = false
    render_component(data)
    assert_select ".app-c-metadata__title", text: t("components.metadata.labels.status"), count: 0
  end

  it "does not render the 'updated' fields when data is not supplied" do
    data[:last_updated] = false
    render_component(data)
    assert_select ".app-c-metadata__title", text: t("components.metadata.labels.last_updated"), count: 0
  end

  it "does not render the 'published' fields when data is not supplied" do
    data[:published_at] = false
    render_component(data)
    assert_select ".app-c-metadata__title", text: t("components.metadata.labels.published_at"), count: 0
  end

  it "does not render the 'organisation' fields when data is not supplied" do
    data[:publishing_organisation] = false
    render_component(data)
    assert_select ".app-c-metadata__title", text: t("components.metadata.labels.publishing_organisation"), count: 0
  end

  def render_component(locals)
    render partial: "components/metadata", locals: locals
  end
end
