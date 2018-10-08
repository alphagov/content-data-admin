RSpec.describe ContentRowPresenter do
  let(:row_hash) do
    {
      base_path: '/some/base_path',
      document_type: 'news_story',
      title: 'a title',
      upviews: 200_001,
      satisfaction: 0.801001,
      satisfaction_score_responses: 301,
    }
  end

  subject { described_class.new(row_hash) }

  it 'returns the basic attributes' do
    expect(subject).to have_attributes(
      base_path: 'some/base_path',
      title: 'a title',
      upviews: 200_001
    )
  end

  it 'converts document_type to human readable format' do
    expect(subject.document_type).to eq('News story')
  end

  it 'formats user_satifaction_score correctly' do
    expect(subject.user_satisfaction_score).to eq('80.1% (301 responses)')
  end
end
