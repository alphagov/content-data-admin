RSpec.describe SingleContentItemPresenter do
  include GdsApi::TestHelpers::ResponseHelpers

  around do |example|
    Timecop.freeze Date.new(2018, 12, 25) do
      example.run
    end
  end

  let(:date_range) { build(:date_range, :past_30_days) }
  let(:current_period_data) { single_page_response('the/base/path', Date.new(2018, 11, 25), Date.new(2018, 12, 24)) }
  let(:previous_period_data) { single_page_response('the/base/path', Date.new(2018, 10, 26), Date.new(2018, 11, 24)) }
  let(:default_timeseries_metrics) {
    [
      {
        name: 'upviews',
        total: 100,
        time_series: [
          {
            date: '2018-11-25',
            value: 100
          }
        ]
      },
      {
        name: 'pviews',
        total: 100,
        time_series: [
          {
            date: '2018-11-25',
            value: 100
          }
        ]
      }
    ]
  }

  subject do
    SingleContentItemPresenter.new(current_period_data, previous_period_data, date_range)
  end

  it_behaves_like 'Metadata presentation'
  it_behaves_like 'Trend percentages presentation'

  describe '#status' do
    context 'when content is published' do
      it 'displays nothing' do
        expect(subject.status).to be_nil
      end
    end
    context 'when content is historical' do
      before { current_period_data[:metadata][:historical] = true }
      it 'displays history mode' do
        expect(subject.status).to eq(I18n.t('components.metadata.statuses.historical'))
      end
    end
    context 'when content is withdrawn' do
      before { current_period_data[:metadata][:withdrawn] = true }
      it 'displays withdrawn' do
        expect(subject.status).to eq(I18n.t('components.metadata.statuses.withdrawn'))
      end
    end
    context 'when content is withdrawn and historical' do
      before {
        current_period_data[:metadata][:historical] = true
        current_period_data[:metadata][:withdrawn] = true
      }
      it 'displays withdrawn and history mode' do
        expect(subject.status).to eq(I18n.t('components.metadata.statuses.withdrawn_and_historical'))
      end
    end
  end

  describe '#searches_context' do
    it 'shows the percentage of users who searched the page' do
      current_period_data[:time_series_metrics] = [{ name: 'upviews', total: 100 }, { name: 'searches', total: 10 }, { name: 'pviews', total: 100 }]
      expect(subject.searches_context).to eq "10.0% of users searched from the page"
    end

    it 'return 0 if there are no unique pageviews' do
      current_period_data[:time_series_metrics] = [{ name: 'upviews', total: 0 }, { name: 'searches', total: 10 }, { name: 'pviews', total: 100 }]
      expect(subject.searches_context).to eq "0% of users searched from the page"
    end

    it 'returns 0 if there have been no searches' do
      current_period_data[:time_series_metrics] = [{ name: 'upviews', total: 10 }, { name: 'searches', total: 0 }, { name: 'pviews', total: 100 }]
      expect(subject.searches_context).to eq "0% of users searched from the page"
    end

    it 'rounds to 2 decimal places' do
      current_period_data[:time_series_metrics] = [{ name: 'upviews', total: 8777 }, { name: 'searches', total: 1753 }, { name: 'pviews', total: 100 }]
      expect(subject.searches_context).to eq "19.97% of users searched from the page"
    end

    it 'caps to a maximum of 100%' do
      current_period_data[:time_series_metrics] = [{ name: 'upviews', total: 100 }, { name: 'searches', total: 900 }, { name: 'pviews', total: 100 }]
      expect(subject.searches_context).to eq "100% of users searched from the page"
    end
  end

  describe '#total_upviews' do
    it 'correctly formats number for a value in the millions' do
      current_period_data[:time_series_metrics] = [{ name: 'upviews', total: 500_000_000 }, { name: 'pviews', total: 0 }]

      expect(subject.total_upviews).to eq('500,000,000')
    end

    it 'correctly formats number for a small value' do
      current_period_data[:time_series_metrics] = [{ name: 'upviews', total: 5 }, { name: 'pviews', total: 0 }]

      expect(subject.total_upviews).to eq('5')
    end
  end

  describe '#total_pviews' do
    it 'correctly formats number for a value in the millions' do
      current_period_data[:time_series_metrics] = [{ name: 'pviews', total: 500_000_000 }, { name: 'upviews', total: 0 }]

      expect(subject.total_pviews).to eq('500,000,000')
    end

    it 'correctly formats number for a small value' do
      current_period_data[:time_series_metrics] = [{ name: 'pviews', total: 5 }, { name: 'upviews', total: 0 }]

      expect(subject.total_pviews).to eq('5')
    end
  end

  describe '#total_searches' do
    it 'correctly formats number for a value in the millions' do
      current_period_data[:time_series_metrics] = [{ name: 'searches', total: 500_000_000 }, { name: 'upviews', total: '0' }, { name: 'pviews', total: 0 }]

      expect(subject.total_searches).to eq('500,000,000')
    end

    it 'correctly formats number for a small value' do
      current_period_data[:time_series_metrics] = [{ name: 'searches', total: 5 }, { name: 'pviews', total: 5 }, { name: 'upviews', total: 0 }]

      expect(subject.total_searches).to eq('5')
    end
  end

  describe '#total_satisfaction' do
    it 'correctly formats number for a value in the millions' do
      current_period_data[:time_series_metrics] = [{ name: 'satisfaction', total: 1 }, { name: 'upviews', total: '0' }, { name: 'pviews', total: 0 }]

      expect(subject.total_satisfaction).to eq('100%')
    end

    it 'correctly formats number for a small value' do
      current_period_data[:time_series_metrics] = [{ name: 'satisfaction', total: 0.01 }, { name: 'pviews', total: 5 }, { name: 'upviews', total: 0 }]

      expect(subject.total_satisfaction).to eq('1%')
    end
  end

  describe '#satisfaction_context' do
    it 'returns context about the satisfaction metric' do
      current_period_data[:time_series_metrics] = [
        { name: 'pviews', total: 5 },
        { name: 'upviews', total: 5 },
        { name: 'useful_yes', total: 5 },
        { name: 'useful_no', total: 10 },
      ]

      expected_context = 'Users who found the page useful, out of 15 responses'
      expect(subject.satisfaction_context).to eq(expected_context)
    end

    it 'does not fail when there are no metrics' do
      current_period_data[:time_series_metrics] = [
        { name: 'pviews', total: 5 },
        { name: 'upviews', total: 5 },
        { name: 'useful_yes', total: nil },
        { name: 'useful_no', total: nil },
      ]

      expected_context = 'Users who found the page useful, out of 0 responses'
      expect(subject.satisfaction_context).to eq(expected_context)
    end
  end

  describe '#total_feedex' do
    it 'correctly formats number for a value in the millions' do
      current_period_data[:time_series_metrics] = [{ name: 'feedex', total: 1_000 }, { name: 'upviews', total: '0' }, { name: 'pviews', total: 0 }]

      expect(subject.total_feedex).to eq('1,000')
    end

    it 'correctly formats number for a small value' do
      current_period_data[:time_series_metrics] = [{ name: 'feedex', total: 1 }, { name: 'pviews', total: 5 }, { name: 'upviews', total: 0 }]

      expect(subject.total_feedex).to eq('1')
    end
  end

  describe '#total_words' do
    it 'correctly formats number for a value in the millions' do
      current_period_data[:edition_metrics] = [{ name: 'words', value: 5_000 }]

      expect(subject.total_words).to eq('5,000')
    end

    it 'correctly formats number for a small value' do
      current_period_data[:edition_metrics] = [{ name: 'words', value: 50 }]

      expect(subject.total_words).to eq('50')
    end
  end

  describe '#total_pdf_count' do
    it 'correctly formats number for a value in the millions' do
      current_period_data[:edition_metrics] = [{ name: 'pdf_count', value: 5_000 }]

      expect(subject.total_pdf_count).to eq('5,000')
    end

    it 'correctly formats number for a small value' do
      current_period_data[:edition_metrics] = [{ name: 'pdf_count', value: 50 }]

      expect(subject.total_pdf_count).to eq('50')
    end
  end

  describe '#pageviews_per_visit' do
    it 'calculates number of times the page was viewed in one visit' do
      current_period_data[:time_series_metrics] = [{ name: 'upviews', total: 50 }, { name: 'pviews', total: 100 }]
      expect(subject.pageviews_per_visit).to eq('2.0')
    end

    it 'return 0 if there are no pageviews' do
      current_period_data[:time_series_metrics] = [{ name: 'upviews', total: 100 }, { name: 'pviews', total: 0 }]
      expect(subject.pageviews_per_visit).to eq('0')
    end

    it 'return 0 if there are no unique pageviews' do
      current_period_data[:time_series_metrics] = [{ name: 'upviews', total: 0 }, { name: 'pviews', total: 100 }]
      expect(subject.pageviews_per_visit).to eq('0')
    end

    it 'rounds to 2 decimal places' do
      current_period_data[:time_series_metrics] = [{ name: 'upviews', total: 4 }, { name: 'pviews', total: 13 }]
      expect(subject.pageviews_per_visit).to eq('3.25')
    end
  end

  describe '#searches_context' do
    it 'returns calculated on page search rate formatted as percentage' do
      expect(subject.searches_context).to include('4.05%')
    end
  end

  describe '#link_text' do
    it 'returns the downcased translation of the metric name' do
      expect(subject.link_text('upviews')).to eq('unique pageviews')
    end
  end

  describe '#feedback_explorer_href' do
    it 'generates a URL to feedback explorer with correct params' do
      expect(subject.feedback_explorer_href).to eq("#{Plek.new.external_url_for('support')}/anonymous_feedback?from=2018-11-25&to=2018-12-24&paths=#{CGI.escape('/the/base/path')}")
    end
  end
end
