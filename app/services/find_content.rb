class FindContent
  include MetricsCommon

  def self.call(params)
    new(params).call
  end

  def self.enum(params)
    new(params).enum
  end

  def initialize(params)
    range = DateRange.new(params[:date_range])
    @from = range.from
    @to = range.to
    @organisation = params[:organisation_id]
    @document_type = params[:document_type]
    @page = params[:page]
    @search_term = params[:search_term]
  end

  def call
    api.content(from: @from, to: @to, organisation_id: @organisation, document_type: @document_type, page: @page, search_term: @search_term)
  end

  def enum
    params = {
      from: @from,
      to: @to,
      organisation_id: @organisation,
      document_type: @document_type,
    }

    Enumerator.new do |yielder|
      (1..Float::INFINITY).each do |index|
        page = api.content(
          params.merge(page: index)
        ).to_h

        page
          .fetch(:results, [])
          .each { |result| yielder << result }

        break if page[:total_pages] <= index
      end
    end
  end
end
