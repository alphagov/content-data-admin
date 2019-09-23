RSpec.describe DocumentChildrenHelper do
  describe "#parent_document_id" do
    context "parent document id is nil" do
      it "return current content id and locale" do
        value = parent_document_id("1234", "en", nil)
        expect(value).to eq "1234:en"
      end
    end

    context "parent document id is present" do
      it "return current content id and locale" do
        value = parent_document_id("1234", "en", "5678:fr")
        expect(value).to eq "5678:fr"
      end
    end
  end
end
