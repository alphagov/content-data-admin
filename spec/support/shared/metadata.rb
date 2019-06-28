RSpec.shared_examples 'Metadata presentation' do
  include GdsApi::TestHelpers::ResponseHelpers

  around do |example|
    Timecop.freeze Date.new(2018, 12, 25) do
      example.run
    end
  end

  let(:date_range) { build(:date_range, :past_30_days) }
  let(:current_period_data) { single_page_response('the/base/path', Date.new(2018, 11, 25), Date.new(2018, 12, 24)) }
  let(:previous_period_data) { single_page_response('the/base/path', Date.new(2018, 10, 26), Date.new(2018, 11, 24)) }

  subject do
    SingleContentItemPresenter.new(current_period_data, previous_period_data, date_range)
  end

  describe '#metadata' do
    it 'returns a hash with the metadata' do
      expect(subject.base_path).to eq('/the/base/path')
      expect(subject.document_type).to eq("News story")
      expect(subject.publishing_organisation).to eq("The Ministry")
    end

    it 'returns the title' do
      expect(subject.title).to eq('Content Title')
    end
  end

  describe '#feedback_explorer_href' do
    it 'returns a URI for the feedback explorer' do
      host = Plek.new.external_url_for('support')
      expected_link = "#{host}/anonymous_feedback?from=2018-11-25&to=2018-12-24&paths=%2Fthe%2Fbase%2Fpath"
      expect(subject.feedback_explorer_href).to eq(expected_link)
    end
  end

  describe '#edit_url' do
    it 'uses the ExternalLinksHelper' do
      allow_any_instance_of(ExternalLinksHelper).to receive(
        :edit_url_for
      ).with(
        content_id: 'content-id',
        locale: 'fr',
        publishing_app: 'whitehall',
        base_path: '/the/base/path',
        document_type: 'news_story',
        parent_content_id: nil
      ).and_return(
        'https://expected-link'
      )

      expect(subject.edit_url).to eq('https://expected-link')
    end
  end

  describe '#edit_label' do
    it 'uses the ExternalLinksHelper' do
      allow_any_instance_of(ExternalLinksHelper).to receive(
        :edit_label_for
      ).with(
        publishing_app: 'whitehall'
      ).and_return(
        'expected-label'
      )

      expect(subject.edit_label).to eq('expected-label')
    end
  end
end
