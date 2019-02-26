class FilterPresenter
  def initialize(search_parameters, document_types, organisations)
    @document_types = document_types
    @search_parameters = search_parameters
    @organisations = organisations
  end

  def search_terms?
    search_terms.present?
  end

  def search_terms
    @search_parameters[:search_term]
  end

  def document_type?
    @search_parameters[:document_type].present?
  end

  def document_type
    find_selected_document_type || ['', '']
  end

  def document_type_id
    find_selected_document_type[1]
  end

  def document_type_name
    document_type[0]
  end

  def selected_document_type(params)
    if params[:submitted].blank?
      ['', '']
    else
      document_type
    end
  end

  def organisation
    find_selected_org || ['', 'all']
  end

  def organisation_name
    org_name = find_selected_org[0]
    if org_name == ""
      "All organisations"
    else
      org_name
    end
  end

  def organisation_id
    find_selected_org
  end

  def selected_organisation(params)
    if params[:submitted].blank?
      ['', '']
    else
      organisation
    end
  end

  def document_type_options
    @document_type_options ||= begin
      types = [['', 'all'], ['All document types', 'all']]
      @document_types.each do |document_type|
        types.push([document_type[:name], document_type[:id]])
      end
      types
    end
  end

  def organisation_options
    @organisation_options ||= begin
      additional_organisation_options +
        @organisations.map do |org|
          name = org[:name].strip
          if org[:acronym].present?
            acronym = org[:acronym].strip
            name.concat " (#{acronym})" if acronym != name
          end
          [name, org[:id]]
        end
    end
  end

private

  def find_selected_org
    organisation_options.find { |o| o[1] == @search_parameters[:organisation_id] } || ['All organisations', 'all']
  end

  def find_selected_document_type
    document_type_options.find { |d| d[1] == @search_parameters[:document_type] } || ['All document types', 'all']
  end

  def additional_organisation_options
    [
      ['', 'all'],
      ['All organisations', 'all'],
      ['No primary organisation', 'none']
    ]
  end
end
