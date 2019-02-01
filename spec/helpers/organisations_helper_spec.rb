RSpec.describe OrganisationsHelper do
  let(:organisations) do
    [
      { id: '6667cce2-e809-4e21-ae09-cb0bdc1ddda3', name: 'HM Revenue & Customs', acryonm: 'HMRC' },
      { id: 'e3b07496-d133-4a87-abcc-9e2f45d570e4', name: 'Dental Practice Board', acryonm: nil },
      { id: 'cb0a039c-a89d-4143-8277-67e18c16c6bf', name: 'Welsh Government', acryonm: nil }
    ]
  end

  describe '#organisation_title' do
    it 'returns title for all organisations' do
      id = 'all'
      expect(organisation_title([], id)).to eq('All organisations')
    end

    it 'returns title for no organisation' do
      id = 'none'
      expect(organisation_title([], id)).to eq('No organisation')
    end

    it 'returns title for known organisation' do
      id = 'e3b07496-d133-4a87-abcc-9e2f45d570e4'
      expect(organisation_title(organisations, id)).to eq('Dental Practice Board')
    end

    it 'returns title for unknown organisation' do
      id = 'ccc9dff8-87b7-4d0f-8d78-b8339063b440'
      expect(organisation_title(organisations, id)).to eq('Unknown organisation')
    end
  end
end
