require 'rails_helper'

RSpec.describe "Glance Metric", type: :view do
  let(:data) {
    {
      name: "Unique pageviews",
      figure: "167",
      measurement_display_label: "m",
      measurement_explicit_label: "million",
      context: "This is in your top 10 items",
      trend_percentage: 0.5,
      period: "Apr 2018 to Mar 2018",
    }
  }

  it "does not render when no data is given" do
    assert_empty render_component({})
  end

  it "does not render if name is not supplied" do
    data[:name] = false
    assert_empty render_component(data)
  end

  it "does not render if figure is not supplied" do
    data[:figure] = false
    assert_empty render_component(data)
  end

  it "does not render if period is not supplied" do
    data[:period] = false
    assert_empty render_component(data)
  end

  it "renders correctly when given valid data" do
    render_component(data)
    assert_select ".app-c-glance-metric"
    assert_select ".app-c-glance-metric__heading", text: "Unique pageviews"
    assert_select ".app-c-glance-metric__figure", text: "167m"
    assert_select ".app-c-glance-metric__measurement[aria-label=million]"
    assert_select ".app-c-glance-metric__context", text: "This is in your top 10 items"
    assert_select ".app-c-glance-metric__trend", text: "+0.5%"
    assert_select ".app-c-glance-metric__period", text: "Apr 2018 to Mar 2018"
  end

  it "does not show an aria label if no explicit measurement label is provided" do
    data[:measurement_explicit_label] = false
    render_component(data)
    assert_select ".app-c-glance-metric__measurement[aria-label=million]", 0
  end

  it "displays the correct trend direction" do
    render_component(data)
    assert_select ".app-c-glance-metric__trend--up .app-c-glance-metric__trend-text", text: "Upward trend"
    data[:trend_percentage] = -2
    render_component(data)
    assert_select ".app-c-glance-metric__trend--down .app-c-glance-metric__trend-text", text: "Downward trend"
    data[:trend_percentage] = 0
    render_component(data)
    assert_select ".app-c-glance-metric__trend--no-change .app-c-glance-metric__trend-text", text: "No change"
  end

  def render_component(locals)
    render partial: "components/glance-metric", locals: locals
  end
end
