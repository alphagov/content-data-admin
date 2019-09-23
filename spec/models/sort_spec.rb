RSpec.describe Sort do
  describe "#valid?" do
    it 'is valid with direction as "asc"' do
      expect(described_class.new("upviews", "asc")).to be_valid
    end

    it 'is valid with direction as "desc"' do
      expect(described_class.new("upviews", "desc")).to be_valid
    end

    it "is valid with non empty key" do
      expect(described_class.new("key", "desc")).to be_valid
    end

    it "is invalid with empty key string" do
      expect(described_class.new("", "asc")).to_not be_valid
    end

    it "is invalid with no key" do
      expect(described_class.new(nil, "asc")).to_not be_valid
    end

    it "is invalid with no direction" do
      expect(described_class.new("upviews", nil)).to_not be_valid
    end

    it "is invalid with invalid direction" do
      expect(described_class.new("upviews", "invalid")).to_not be_valid
    end
  end

  describe ".parse" do
    it "parses a correctly formatted string" do
      sort = described_class.parse("upviews:desc")

      expect(sort).to have_attributes(key: "upviews", direction: "desc")
    end

    it "parses string with extra colon" do
      sort = described_class.parse("upviews:desc:extra")

      expect(sort).to have_attributes(key: "upviews", direction: "desc")
    end

    it "parses string with no direction" do
      sort = described_class.parse("upviews")

      expect(sort).to have_attributes(key: "upviews", direction: "")
    end

    it "parses string with no key" do
      sort = described_class.parse(":desc")

      expect(sort).to have_attributes(key: "", direction: "desc")
    end

    it "parses an empty string" do
      sort = described_class.parse("")

      expect(sort).to have_attributes(key: "", direction: "")
    end
  end

  describe "#to_s" do
    it "prints string with key and direction" do
      result = described_class.new("upviews", "desc").to_s
      expect(result).to eq("upviews:desc")
    end
  end

  describe "#reverse!" do
    it 'reverses "asc" to "desc"' do
      sort = described_class.new("", "asc")
      sort.reverse!
      expect(sort.direction).to eq("desc")
    end

    it 'reverses "desc" to "asc"' do
      sort = described_class.new("", "desc")
      sort.reverse!
      expect(sort.direction).to eq("asc")
    end
  end
end
