require 'csv'

class MetricsCSVPresenter
  ROW_TITLES = %w(Date Value).freeze

  def initialize(time_series, base_path, metric_name)
    @time_series = time_series
    @base_path = base_path
    @metric_name = metric_name
  end

  def csv_rows
    CSV.generate do |csv|
      csv << ROW_TITLES
      @time_series.each do |metric|
        csv << [metric[:date], metric[:value]]
      end
    end
  end

  def filename
    date = Time.zone.today.strftime
    slug = @base_path.split.last
    metric_name = I18n.t "metrics.#{@metric_name}.title"

    "#{date}_#{metric_name}_#{slug}"
  end
end
