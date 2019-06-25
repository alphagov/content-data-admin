class ContentRowPresenter
  include ActionView::Helpers::NumberHelper
  include ActiveSupport::Inflector

  attr_reader :title, :base_path, :document_type, :upviews, :searches,
              :raw_document_type, :satisfaction_percentage,
              :satisfaction_responses, :sibling_order

  def initialize(data)
    @title = data[:title]
    @base_path = format_base_path(data[:base_path])
    @raw_document_type = data[:document_type]
    @document_type = humanize(data[:document_type])
    @sibling_order = data[:sibling_order] || '-'
    @upviews = number_with_delimiter(data[:upviews], delimiter: ',') || 'No data'
    @satisfaction_percentage = format_satisfaction_percentage(data[:satisfaction])
    @satisfaction_responses = format_satisfaction_responses(data[:useful_yes], data[:useful_no])

    @searches = number_with_delimiter(data[:searches], delimiter: ',') || 'No data'
  end

private

  def format_satisfaction_percentage(score)
    "#{(score * 100).round(0)}%" if score
  end

  def format_satisfaction_responses(yes_responses, no_responses)
    return 'No data' if yes_responses.nil? || no_responses.nil?

    total_responses = yes_responses + no_responses

    if total_responses.positive?
      "#{number_with_delimiter(total_responses)} responses"
    else
      "No responses"
    end
  end

  def format_base_path(base_path)
    #  remove '/' to make base_path usable in links
    base_path.delete_prefix('/')
  end
end
