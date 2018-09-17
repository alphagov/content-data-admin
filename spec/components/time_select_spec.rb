require 'rails_helper'

RSpec.describe "Time Select", type: :view do
  let(:data) {
    {
    base_path: "/metrics",
    current_selection: 'last-30-days',
      dates: [
        {
          value: "last-30-days",
          text: "Past 30 Days",
          hint_text:  "19 August 2018 to 18 September 2018"
        },
        {
          value: "last-month",
          text: "Last month",
          hint_text: "1 August 2018 to 31 August 2018"
        },
        {
          value: "last-3-months",
          text: "Past 3 months",
          hint_text: "18 June 2018 to 18 September 2018"
        }
      ]
    }
  }

  it "does not render when not enough dates are given" do
    data[:dates] = []
    assert_empty render_component(data)
    data[:dates] = [{ value: "last-30-days", text: "Past 30 Days", hint_text: "19 August 2018 to 18 September 2018" }]
    assert_empty render_component(data)
  end

  it "does not render when current_selection is not supplied" do
    data[:current_selection] = false
    assert_empty render_component(data)
  end

  it "does not render when base_path is not supplied" do
    data[:base_path] = false
    assert_empty render_component(data)
  end

  it "renders correctly when given valid data" do
    render_component(data)
    assert_select ".app-c-time-select", 1
    assert_select ".govuk-radios__item", 3
    assert_select "label", text: "Past 30 Days"
    assert_select "label", text: "Last month"
    assert_select "label", text: "Past 3 months"
    assert_select "input[type=radio][value=last-30-days][checked=checked]"
  end

  it "preselects the radio button based on the current_selection parameter" do
    data[:current_selection] = "last-3-months"
    render_component(data)
    assert_select "input[type=radio][value=last-3-months][checked=checked]"
  end

  def render_component(locals)
    render partial: "components/time-select", locals: locals
  end
end
