RSpec.describe "routes for Help" do
  it "routes /help to Help" do
    expect(get("/help")).to route_to("help#show")
  end

  it "does not route /help/<id>" do
    expect(get("/help/1")).not_to be_routable
  end
end
