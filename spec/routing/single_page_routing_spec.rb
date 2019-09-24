RSpec.describe "routes for Single Data Page" do
  it 'routes /metrics/base/path to Single Data Page for "base/path"' do
    expect(get: "/metrics/base/path").to route_to(
      controller: "metrics",
      action: "show",
      base_path: "base/path",
    )
  end

  it "routes /metrics to Single Data Page for the homepage" do
    expect(get: "/metrics").to route_to(
      controller: "metrics",
      action: "show",
    )
  end

  it "routes /metrics/base/path.cy" do
    expect(get: "/metrics/base/path.cy").to route_to(
      controller: "metrics",
      action: "show",
      base_path: "base/path.cy",
    )
  end
end
