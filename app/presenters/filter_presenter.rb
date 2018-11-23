class FilterPresenter
  def initialize(search_parameters, document_types, organisations)
    @document_types = document_types
    @search_parameters = search_parameters
    @organisations = organisations
  end

  def document_type?
    !@search_parameters[:document_type].blank?
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
    @organisations.map do |org|
      {
        text: org[:title],
        value: org[:organisation_id],
        selected: org[:organisation_id] == @search_parameters[:organisation_id]
      }
    end
  end
end
