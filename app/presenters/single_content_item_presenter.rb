class SingleContentItemPresenter
  include MetricsFormatterHelper
  include ExternalLinksHelper

  attr_reader :date_range

  def initialize(current_period_data, previous_period_data, date_range)
    @single_page_data = current_period_data

    @date_range = date_range
    @metrics = Metric.parse_metrics(current_period_data)
    @previous_metrics = Metric.parse_metrics(previous_period_data)

    assign_pageviews_per_visit
  end

  def abbreviated_total_upviews
    abbreviate(value_for('upviews'))
  end

  def abbreviated_total_searches
    abbreviate(value_for('searches'))
  end

  def abbreviated_total_feedex
    abbreviate(value_for('feedex'))
  end

  def total_upviews
    number_with_delimiter value_for('upviews')
  end

  def total_pviews
    number_with_delimiter value_for('pviews')
  end

  def total_searches
    number_with_delimiter value_for('searches')
  end

  def total_satisfaction
    number_to_percentage(value_for('satisfaction') * 100, precision: 0)
  end

  def total_feedex
    number_with_delimiter value_for('feedex')
  end

  def total_words
    number_with_delimiter value_for('words')
  end

  def total_pdf_count
    number_with_delimiter value_for('pdf_count')
  end

  def pageviews_per_visit
    number_with_delimiter value_for('pageviews_per_visit')
  end

  def reading_time
    format_duration(@metrics['reading_time'][:value])
  end

  def upviews_context
    I18n.t("metrics.upviews.context", percent_org_views: 2.74)
  end

  def satisfaction_context
    I18n.t("metrics.satisfaction.context",
      total_responses: number_with_delimiter(useful_yes_no_total),
      count: useful_yes_no_total)
  end

  def satisfaction_short_context
    I18n.t("metrics.satisfaction.short_context",
      total_responses: number_with_delimiter(useful_yes_no_total),
      count: useful_yes_no_total)
  end

  def searches_context
    on_page_search_rate = Calculator::AverageSearchesPerUser.calculate(
      searches: value_for('searches'),
      unique_pageviews: value_for('upviews')
    )
    I18n.t("metrics.searches.context", percent_users_searched: on_page_search_rate)
  end

  def feedex_context
    I18n.t("metrics.feedex.context")
  end

  def feedback_explorer_href
    feedex_url(from: date_range.from, to: date_range.to, base_path: base_path)
  end

  def search_terms_href
    google_analytics_url(from: date_range.from, to: date_range.to, base_path: base_path)
  end

  def period
    I18n.t("metrics.show.time_periods.#{@date_range.time_period}.reference")
  end

  def metric_title(metric_name)
    I18n.t("metrics.#{metric_name}.title")
  end

  def metric_short_title(metric_name)
    I18n.t("metrics.#{metric_name}.short_title")
  end

  def metric_about_label(metric_name)
    I18n.t("metrics.#{metric_name}.about_title")
  end

  def trend_percentage(metric_name)
    current_value = @metrics[metric_name]
    previous_value = @previous_metrics[metric_name]
    calculate_trend_percentage(current_value, previous_value, metric_name)
  end

  def edit_url
    edit_url_for(
      content_id: metadata[:content_id],
      publishing_app: metadata[:publishing_app],
      base_path: base_path,
      parent_content_id: metadata[:parent_content_id],
      document_type: metadata[:document_type]
    )
  end

  def edit_label
    edit_label_for(publishing_app: metadata[:publishing_app])
  end

  def title
    metadata[:title]
  end

  def base_path
    metadata[:base_path]
  end

  def link_text(metric_name)
    I18n.t("metrics.#{metric_name}.title").try(:downcase)
  end

  def document_type
    metadata[:document_type].tr('_', ' ').capitalize
  end

  def publishing_organisation
    metadata[:primary_organisation_title]
  end

  def status
    if metadata[:withdrawn] && metadata[:historical]
      I18n.t('components.metadata.statuses.withdrawn_and_historical')
    elsif metadata[:withdrawn]
      I18n.t('components.metadata.statuses.withdrawn')
    elsif metadata[:historical]
      I18n.t('components.metadata.statuses.historical')
    end
  end

  def chart_for_metric(metric_name)
    time_series = @metrics[metric_name][:time_series]
    ChartPresenter.new(json: time_series, metric: metric_name, date_range: date_range)
  end

private

  def abbreviate(number)
    {
      figure: number_to_human(number, format: '%n'),
      display_label: number_to_human(number, format: '%u', units: { unit: "", thousand: "k", million: "m", billion: "b" }),
      explicit_label: number_to_human(number, format: '%u')
    }
  end

  def value_for(metric)
    @metrics[metric][:value]
  end

  def useful_yes_no_total
    value_for('useful_yes').to_i + value_for('useful_no').to_i
  end

  def metadata
    @metadata ||= @single_page_data[:metadata]
  end

  def assign_pageviews_per_visit
    current = Calculator::PageviewsPerVisit.calculate(
      pageviews: value_for('pviews'),
      unique_pageviews: value_for('upviews')
    )
    @metrics['pageviews_per_visit'] = { value: current }

    previous = Calculator::PageviewsPerVisit.calculate(
      pageviews: @previous_metrics['pviews'][:value],
      unique_pageviews: @previous_metrics['upviews'][:value]
    )
    @previous_metrics['pageviews_per_visit'] = { value: previous }
  end

  def calculate_trend_percentage(current_value, previous_value, metric_name)
    return if incomplete_previous_data?(current_value, previous_value, metric_name)

    Calculator::TrendPercentage.calculate(current_value[:value], previous_value[:value])
  end

  def incomplete_previous_data?(current_value, previous_value, metric_name)
    return incomplete_previous_pageviews_per_visit_data? if metric_name == 'pageviews_per_visit'
    return true if no_previous_timeseries?(previous_value)
    return incomplete_last_month_data?(previous_value) if @date_range.time_period == 'last-month'

    current_value[:time_series].length != previous_value[:time_series].length
  end

  def no_previous_timeseries?(previous_value)
    previous_value[:time_series].blank?
  end

  def incomplete_previous_pageviews_per_visit_data?
    incomplete_previous_data?(@metrics['pviews'], @previous_metrics['pviews'], 'pviews') && incomplete_previous_data?(@metrics['upviews'], @previous_metrics['upviews'], 'upviews')
  end

  def incomplete_last_month_data?(previous_value)
    previous_date = @previous_metrics['upviews'][:time_series].first[:date].to_date
    days_in_month = Time.days_in_month(previous_date.month, previous_date.year)
    days_in_month != previous_value[:time_series].length
  end
end
