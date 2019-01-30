RSpec.describe TimeSelectHelper do
  around do |example|
    Timecop.freeze Date.new(2018, 12, 31) do
      example.run
    end
  end

  context 'metrics page' do
    let(:time_periods) { TimeSelectHelper::METRIC_PAGE_TIME_PERIODS }

    describe '#time_select_options' do
      it 'returns options for time select' do
        options = time_select_options(time_periods)
        expect(options).to eq([
          {
            value: "past-30-days",
            text: I18n.t("metrics.show.time_periods.past-30-days.leading"),
            hint_text: "1 December 2018 to 30 December 2018"
          },
          {
            value: "last-month",
            text: I18n.t("metrics.show.time_periods.last-month.leading"),
            hint_text: "1 November 2018 to 30 November 2018"
          },
          {
            value: "past-3-months",
            text: I18n.t("metrics.show.time_periods.past-3-months.leading"),
            hint_text: "1 October 2018 to 30 December 2018"
          },
          {
            value: "past-6-months",
            text: I18n.t("metrics.show.time_periods.past-6-months.leading"),
            hint_text: "1 July 2018 to 30 December 2018"
          },
          {
            value: "past-year",
            text: I18n.t("metrics.show.time_periods.past-year.leading"),
            hint_text: "31 December 2017 to 30 December 2018"
          },
          {
            value: "past-2-years",
            text: I18n.t("metrics.show.time_periods.past-2-years.leading"),
            hint_text: "31 December 2016 to 30 December 2018"
          }
        ])
      end
    end
  end
end
