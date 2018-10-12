RSpec.describe GlanceMetricPresenter do
  let(:from) { '2018-01-13' }
  let(:to) { '2018-01-15' }

  before(:each) do
    en = { metrics: {
            example_metric: {
              title: 'Example metric full title',
              short_title: 'Example metric short title',
              context: {
                total_responses: 'Users who found this page useful, out of some responses'
              }
            },
            show: {
              time_periods: {
                last_30_days: {
                  reference: "from previous 30 days"
                }
              }
            }
        } }
    I18n.backend.store_translations(:en, en)
  end

  subject do
    GlanceMetricPresenter.new(
      "example_metric", 10, 'last-30-days', context: { total_responses: 505 }
    )
  end

  it 'returns short metric name when available' do
    expect(subject.name).to eq I18n.t('metrics.example_metric.short_title')
  end

  it 'returns full metric name when short title unavailable' do
    change_metric_translation(:short_title, '')
    expect(subject.name).to eq I18n.t('metrics.example_metric.title')
  end

  it 'returns metric value' do
    expect(subject.value).to eq 10
  end

  it 'returns trend percentage' do
    expect(subject.trend_percentage).to eq 0
  end

  it 'returns context' do
    expect(subject.context).to eq I18n.t('metrics.example_metric.context')
  end

  it 'returns context using context metrics' do
    change_metric_translation(:context, 'Metric context with %<total_responses>s')
    expect(subject.context).to eq I18n.t('metrics.example_metric.context', total_responses: 505)
  end

  it 'returns time period text' do
    expect(subject.period).to eq I18n.t('metrics.show.time_periods.last_30_days.reference')
  end

  context "when metric is searches" do
    subject do
      GlanceMetricPresenter.new(
        :searches, 107, 'last-30-days', 9794
      )
    end

    it "displays searches divided by unique pageviews as `on_page_search_rate` to 2 decimal places" do
      expect(subject.on_page_search_rate).to eq 1.09
    end
  end

  def change_metric_translation(attribute, value)
    en = { metrics: { example_metric: { attribute => value } } }
    I18n.backend.store_translations(:en, en)
  end
end
