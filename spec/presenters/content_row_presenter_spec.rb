RSpec.describe ContentRowPresenter do
  let(:row_hash) do
    {
      base_path: '/some/base_path',
      document_type: 'news_story',
      title: 'a title',
      upviews: 200_001,
      satisfaction: 0.801,
      useful_yes: 801,
      useful_no: 199,
    }
  end

  subject { described_class.new(row_hash) }

  it 'returns the basic attributes' do
    expect(subject).to have_attributes(
      base_path: 'some/base_path',
      raw_document_type: 'news_story',
      title: 'a title',
      upviews: '200,001'
    )
  end

  it 'converts document_type to human readable format' do
    expect(subject.document_type).to eq('News story')
  end

  it 'formats user_satifaction_percentage correctly' do
    expect(subject.satisfaction_percentage).to eq('80%')
  end

  it 'formats user_satifaction_responses correctly' do
    expect(subject.satisfaction_responses).to eq('1,000 responses')
  end

  context 'when there is no satisfaction score' do
    let(:row_hash) do
      {
        base_path: '/some/base_path',
        document_type: 'news_story',
        title: 'a title',
        upviews: '200,001',
        satisfaction: nil,
        useful_yes: 0,
        useful_no: 0,
      }
    end

    it 'returns nil for percentage' do
      expect(subject.satisfaction_percentage).to eq(nil)
    end

    it 'returns "no responses" for responses' do
      expect(subject.satisfaction_responses).to eq("No responses")
    end
  end
end
