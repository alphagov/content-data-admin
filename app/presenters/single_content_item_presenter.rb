class SingleContentItemPresenter
  include MetricsFormatterHelper
  include ExternalLinksHelper
  include CustomMetricsHelper

  attr_reader :date_range

  def initialize(current_period_data, previous_period_data, date_range)
    @single_page_data = current_period_data

    @date_range = date_range
    @metrics = parse_metrics(
      current_period_data[:time_series_metrics],
      current_period_data[:edition_metrics]
    )
    @previous_metrics = parse_metrics(
      previous_period_data[:time_series_metrics],
      previous_period_data[:edition_metrics]
    )
    assign_pageviews_per_visit
  end

  def total_upviews
    number_with_delimiter @metrics['upviews'][:value]
  end

  def total_pviews
    number_with_delimiter @metrics['pviews'][:value]
  end

  def total_searches
    number_with_delimiter @metrics['searches'][:value]
  end

  def total_satisfaction
    number_to_percentage(@metrics['satisfaction'][:value] * 100, precision: 0)
  end

  def total_feedex
    number_with_delimiter @metrics['feedex'][:value]
  end

  def total_words
    number_with_delimiter @metrics['words'][:value]
  end

  def total_pdf_count
    number_with_delimiter @metrics['pdf_count'][:value]
  end

  def pageviews_per_visit
    number_with_delimiter @metrics['pageviews_per_visit'][:value]
  end

  def upviews_context
    I18n.t("metrics.upviews.context", percent_org_views: 2.74)
  end

  def satisfaction_context
    I18n.t("metrics.satisfaction.context", total_responses: number_with_delimiter(useful_yes_no_total))
  end

  def satisfaction_short_context
    I18n.t("metrics.satisfaction.short_context", total_responses: number_with_delimiter(useful_yes_no_total))
  end

  def searches_context
    I18n.t("metrics.searches.context", percent_users_searched: on_page_search_rate)
  end

  def feedex_context
    I18n.t("metrics.feedex.context")
  end

  def feedback_explorer_href
    host = Plek.new.external_url_for('support')
    from = @date_range.from
    to = @date_range.to
    path = CGI.escape(base_path)
    "#{host}/anonymous_feedback?from=#{from}&to=#{to}&paths=#{path}"
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
    short_title = metric_short_title(metric_name).downcase
    I18n.t("components.info-metric.about_dropdown", metric_short_title: short_title)
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

  def get_chart(metric_name)
    time_series = @metrics[metric_name][:time_series]
    ChartPresenter.new(json: time_series, metric: metric_name, date_range: date_range)
  end

private

  def useful_yes_no_total
    @metrics['useful_yes'][:value] + @metrics['useful_no'][:value]
  end

  def on_page_search_rate
    searches = @metrics['searches'][:value].to_f
    upviews = @metrics['upviews'][:value].to_f

    return 0 if searches.zero? || upviews.zero?

    search_rate = (searches / upviews) * 100
    search_rate = 100 if search_rate > 100
    search_rate.round(2)
  end

  def metadata
    @metadata ||= @single_page_data[:metadata]
  end

  def parse_metrics(time_series_metrics, edition_metrics)
    metrics = {}
    time_series_metrics.each do |metric|
      metrics[metric[:name]] = {
        'value': metric[:total],
        'time_series': metric[:time_series]
      }
    end

    edition_metrics.each do |metric|
      metrics[metric[:name]] = {
        'value': format_metric_value(metric[:name], metric[:value]),
        'time_series': nil
      }
    end
    metrics
  end

  def assign_pageviews_per_visit
    current = calculate_pageviews_per_visit(
      pageviews: @metrics['pviews'][:value],
      unique_pageviews: @metrics['upviews'][:value]
    )
    @metrics['pageviews_per_visit'] = { value: current }

    previous = calculate_pageviews_per_visit(
      pageviews: @previous_metrics['pviews'][:value],
      unique_pageviews: @previous_metrics['upviews'][:value]
    )
    @previous_metrics['pageviews_per_visit'] = { value: previous }
  end

  def calculate_trend_percentage(current_value, previous_value, metric_name)
    return if incomplete_previous_data?(current_value, previous_value, metric_name)

    Calculator::TrendPercentage.new(current_value[:value], previous_value[:value]).run
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
