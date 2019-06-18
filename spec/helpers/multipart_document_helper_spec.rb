RSpec.describe MultipartDocumentHelper do
  describe '#multipart?' do
    multipart_document_types = ["HTML Publication", "Guide", "Manual"]

    multipart_document_types.each do |document_type|
      it "returns true with #{document_type}" do
        expect(multipart?(document_type)).to eq(true)
      end
    end

    it 'returns false for other document types' do
      expect(multipart?('Calculator')).to eq(false)
    end
  end

  describe '#part_name' do
    it 'returns the correct part name for each multipart document type' do
      expect(part_name('HTML Publication')).to eq("publications")
      expect(part_name('Guide')).to eq("chapters")
      expect(part_name('Manual')).to eq("sections")
    end
  end
end
