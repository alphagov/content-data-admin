RSpec.describe ContentRowPresenter do
  let(:row_hash) do
    {
      base_path: "/some/base_path",
      document_type: "news_story",
      title: "a title",
      upviews: 200_001,
      satisfaction: 0.801,
      useful_yes: 801,
      useful_no: 199,
    }
  end

  let(:additional_params) { {} }

  subject { described_class.new(row_hash.merge(additional_params)) }

  it "returns the basic attributes" do
    expect(subject).to have_attributes(
      base_path: "some/base_path",
      raw_document_type: "news_story",
      title: "a title",
      upviews: "200,001",
    )
  end

  it "converts document_type to human readable format" do
    expect(subject.document_type).to eq("News story")
  end

  it "formats user_satifaction_percentage correctly" do
    expect(subject.satisfaction_percentage).to eq("80%")
  end

  it "formats user_satifaction_responses correctly" do
    expect(subject.satisfaction_responses).to eq("1,000 responses")
  end

  describe "#sibling_order" do
    it "it returns dash if nil" do
      expect(subject.sibling_order).to eq("-")
    end

    context "when sibling_order is set" do
      let(:additional_params) { { sibling_order: 1 } }

      it "it returns the order number" do
        expect(subject.sibling_order).to eq(1)
      end
    end
  end

  context "when there is no satisfaction score" do
    let(:row_hash) do
      {
        base_path: "/some/base_path",
        document_type: "news_story",
        title: "a title",
        upviews: 200_001,
        satisfaction: nil,
        useful_yes: 0,
        useful_no: 0,
      }
    end

    it "returns nil for percentage" do
      expect(subject.satisfaction_percentage).to eq(nil)
    end

    it 'returns "no responses" for responses' do
      expect(subject.satisfaction_responses).to eq("No responses")
    end
  end

  context "when there is nil for useful_yes" do
    let(:additional_params) { { useful_yes: nil } }

    it "returns nil for percentage" do
      expect(subject.satisfaction_responses).to eq("No data")
    end
  end

  context "when there is nil for useful_no" do
    let(:additional_params) { { useful_no: nil } }

    it "returns nil for percentage" do
      expect(subject.satisfaction_responses).to eq("No data")
    end
  end

  context "when there is nil for upviews" do
    let(:additional_params) { { upviews: nil } }

    it "returns nil for percentage" do
      expect(subject.upviews).to eq("No data")
    end
  end

  context "when there is nil for searches" do
    let(:additional_params) { { searches: nil } }

    it "returns nil for percentage" do
      expect(subject.searches).to eq("No data")
    end
  end
end
