class ContentRowPresenter
  include ActionView::Helpers::NumberHelper
  include ActiveSupport::Inflector

  attr_reader :title, :base_path, :document_type, :upviews,
              :user_satisfaction, :searches, :raw_document_type
  def initialize(data)
    @title = data[:title]
    @base_path = format_base_path(data[:base_path])
    @raw_document_type = data[:document_type]
    @document_type = humanize(data[:document_type])
    @upviews = number_with_delimiter(data[:upviews], delimiter: ',')
    @user_satisfaction = format_satisfaction(
      data[:satisfaction], data[:useful_yes], data[:useful_no]
    )
    @searches = number_with_delimiter(data[:searches], delimiter: ',')
  end

private

  def format_satisfaction(score, yes_responses, no_responses)
    return 'No responses' unless score

    total_responses = yes_responses + no_responses
    "#{(score * 100).round(0)}% (#{number_with_delimiter(total_responses)} responses)"
  end

  def format_base_path(base_path)
    #  remove '/' to make base_path usable in links
    base_path.delete_prefix('/')
  end
end
