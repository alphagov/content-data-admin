RSpec.describe TableHeaderHelper do
  describe '#include_help_icon?' do
    help_icon_headers = %w(upviews satisfaction searches)

    help_icon_headers.each do |header_name|
      it "returns true with #{header_name} header" do
        expect(include_help_icon?(header_name)).to eq(true)
      end
    end

    it 'returns false for other header name' do
      expect(include_help_icon?('title')).to eq(false)
    end
  end

  describe '#aria_sort' do
    it 'returns acending with "asc"' do
      expect(aria_sort('asc')).to eq('ascending')
    end

    it 'returns acending with "desc"' do
      expect(aria_sort('desc')).to eq('descending')
    end

    it 'returns none with missing sort direction' do
      expect(aria_sort(nil)).to eq('none')
    end
  end

  describe '#sort_param' do
    context 'on sorted column' do
      it 'returns reversed param orginally with desc' do
        expect(sort_param('upviews', 'desc')).to eq('upviews:asc')
      end

      it 'return reversed param orginally with asc' do
        expect(sort_param('upviews', 'asc')).to eq('upviews:desc')
      end
    end

    context 'on unsorted column' do
      default_desc_headers = %w(upviews satisfaction searches)

      default_desc_headers.each do |header|
        it "defaults to desc with #{header} header" do
          expect(sort_param(header, nil)).to eq("#{header}:desc")
        end
      end

      default_asc_headers = %w(title document_type)

      default_asc_headers.each do |header|
        it "defaults to asc with #{header} header" do
          expect(sort_param(header, nil)).to eq("#{header}:asc")
        end
      end
    end
  end
end
