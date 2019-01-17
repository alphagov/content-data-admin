class FindContent
  include MetricsCommon

  def self.call(params)
    new(params).call
  end

  def self.enum(params)
    new(params).enum
  end

  def initialize(params)
    @date_range = params[:date_range]
    @organisation = params[:organisation_id]
    @document_type = params[:document_type]
    @page = params[:page]
    @search_term = params[:search_term]
  end

  def call
    if @document_type == "all"
      @document_type = ""
    end
    api.content(date_range: @date_range, organisation_id: @organisation, document_type: @document_type, page: @page, search_term: @search_term)
  end

  def enum
    params = {
      date_range: @date_range,
      organisation_id: @organisation,
      document_type: @document_type,
      search_term: @search_term,
    }

    Enumerator.new do |yielder|
      (1..Float::INFINITY).each do |index|
        page = api.content(
          params.merge(page: index, page_size: 5000)
        ).to_h

        page
          .fetch(:results, [])
          .each { |result| yielder << result }

        break if page[:total_pages] <= index
      end
    end
  end
end
