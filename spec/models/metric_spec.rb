RSpec.describe Metric do
  describe ".parse_metrics" do
    it "parses API data payload" do
      metric_data =
        {
          edition_metrics: [
            {
              name: "words",
              value: 200,
            },
            {
              name: "pdf_count",
              value: 3,
            },
          ],
          time_series_metrics: [
            {
              name: "upviews",
              total: 100,
              time_series: [
                {
                  date: "2018-11-25",
                  value: 100,
                },
              ],
            },
            {
              name: "pviews",
              total: 100,
              time_series: [
                {
                  date: "2018-11-25",
                  value: 100,
                },
              ],
            },
          ],
        }
      metrics = Metric.parse_metrics(metric_data)

      expect(metrics).not_to be_empty
      expect(metrics).to eq("upviews" => { value: 100, time_series: [{ date: "2018-11-25", value: 100 }] },
        "pviews" => { value: 100, time_series: [{ date: "2018-11-25", value: 100 }] },
        "words" => { value: 200, time_series: nil },
        "pdf_count" => { value: 3, time_series: nil })
    end
  end
end
