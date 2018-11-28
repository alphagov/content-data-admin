class FilterPresenter
  def initialize(search_parameters, document_types, organisations)
    @document_types = document_types
    @search_parameters = search_parameters
    @organisations = organisations
  end

  def document_type?
    @search_parameters[:document_type].present?
  end

  def document_type
    find_document_type[:text]
  end

  def document_type_options
    types = [{
               text: 'All document types',
               value: '',
               selected: @search_parameters[:document_type] == ''
             }]
    @document_types.each do |document_type|
      types.push(
        text: document_type.try(:tr, '_', ' ').try(:capitalize),
        value: document_type,
        selected: document_type == @search_parameters[:document_type]
      )
    end
    types
  end

  def organisation_options
    additional_organisation_options +
      @organisations.map do |org|
        {
          text: org[:title],
          value: org[:organisation_id],
          selected: org[:organisation_id] == @search_parameters[:organisation_id]
        }
      end
  end

  def organisation_name
    find_selected_org[:text]
  end

private

  def find_selected_org
    organisation_options.find { |o| o[:selected] }
  end

  def find_document_type
    document_type_options.find { |d| d[:selected] }
  end

  def additional_organisation_options
    [
      { text: 'All organisations', value: 'all', selected: @search_parameters[:organisation_id] == 'all' },
      { text: 'No primary organisation', value: 'none', selected: @search_parameters[:organisation_id] == 'none' }
    ]
  end
end
