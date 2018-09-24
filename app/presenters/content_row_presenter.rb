class ContentRowPresenter
  attr_reader :title, :base_path, :document_type, :unique_pageviews,
              :user_satisfaction_score, :number_of_internal_searches
  def initialize(data)
    @title = data[:title]
    @base_path = format_base_path(data[:base_path])
    @document_type = data[:document_type].try(:tr, '_', ' ').try(:capitalize)
    @unique_pageviews = data[:unique_pageviews]
    @user_satisfaction_score = format_satisfaction_score(data[:satisfaction_score], data[:satisfaction_score_responses])
    @number_of_internal_searches = data[:number_of_internal_searches]
  end

private

  def format_satisfaction_score(score, responses)
    return 'No responses' unless score

    "#{(score * 100).round(1)}% (#{responses} responses)"
  end

  def format_base_path(base_path)
    #  remove '/' to make base_path usable in links
    base_path.delete_prefix('/')
  end
end
