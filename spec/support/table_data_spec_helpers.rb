module TableDataSpecHelpers
  def extract_table_content(css_selector)
    find(css_selector, visible: false).all("tr", visible: false).map do |el|
      el.all("th,td", visible: false).map do |td|
        td.text(:all)
      end
    end
  end
end
