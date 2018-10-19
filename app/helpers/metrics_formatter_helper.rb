module MetricsFormatterHelper
  include ActionView::Helpers::NumberHelper
  METRICS_MEASURED_AS_PERCENTAGES = %w(satisfaction).freeze

  def format_metric_value(metric_name, figure)
    if METRICS_MEASURED_AS_PERCENTAGES.include?(metric_name) && figure
      number_to_percentage(figure * 100, precision: 3)
    else
      figure
    end
  end
end
