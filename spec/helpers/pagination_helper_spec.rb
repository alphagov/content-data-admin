RSpec.describe PaginationHelper do
  let(:date_range) { DateRange.new('last-30-days') }
  before do
    controller.params[:action] = 'index'
    controller.params[:controller] = 'content'
    controller.params[:organisation_id] = 'org-1'
    assign :content, content
  end

  context 'when on the first page' do
    let(:content) { ContentItemsPresenter.new([], date_range, 300, 3, 1) }
    it 'only returns the `Next` link' do
      expect(navigation_links).to eq(next_page: { url: "/content?organisation_id=org-1&page=2",
                                                                  title: 'Next',
                                                                  label: '2 of 3' })
    end
  end

  context 'when on the last page' do
    let(:content) { ContentItemsPresenter.new([], date_range, 300, 3, 3) }

    it 'only returns the `Previous` link' do
      expect(navigation_links).to eq(previous_page: { url: "/content?organisation_id=org-1&page=2",
                                                  title: 'Previous',
                                                  label: '2 of 3' })
    end
  end

  context 'when in the middle somewhere' do
    let(:content) { ContentItemsPresenter.new([], date_range, 300, 3, 2) }

    it 'returns `Previous` and `Next` links' do
      expect(navigation_links).to eq(previous_page: { url: "/content?organisation_id=org-1",
                                                      title: 'Previous',
                                                      label: '1 of 3' },
                                     next_page: { url: "/content?organisation_id=org-1&page=3",
                                                  title: 'Next',
                                                  label: '3 of 3' })
    end
  end
end
