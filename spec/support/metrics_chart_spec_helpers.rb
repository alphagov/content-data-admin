module MetricsChartSpecHelpers
  def extract_table_content(css_selector)
    find(css_selector).all('tr').map do |el|
      el.all('th,td').map(&:text)
    end
  end
end
