module MetricsFormatterHelper
  include ActionView::Helpers::NumberHelper
  METRICS_MEASURED_AS_PERCENTAGES = %w[satisfaction].freeze

  def format_metric_value(metric_name, figure)
    if METRICS_MEASURED_AS_PERCENTAGES.include?(metric_name) && figure
      number_to_percentage(figure * 100, precision: 0)
    else
      figure
    end
  end

  def format_duration(minutes)
    return nil unless minutes

    dur = ActiveSupport::Duration.build(minutes * 60)
    Time.zone.at(dur).utc.to_s(:reading_time)
  end
end
