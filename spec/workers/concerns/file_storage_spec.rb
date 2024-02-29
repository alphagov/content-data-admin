RSpec.describe "FileStorage" do
  include FileStorage
  describe "#upload_csv_to_s3" do
    before do
      Timecop.freeze(Time.new(2019, 5, 4, 3, 2, 1, "+00:00"))
      ENV["AWS_CSV_EXPORT_BUCKET_NAME"] = "test-bucket"
    end

    after do
      Timecop.return
    end

    it "returns the public url" do
      url = upload_csv_to_s3("basename", "")

      expect(url).to eq("https://test-bucket.s3.amazonaws.com/2019-05-04-03-02-01/basename.csv")
    end
  end
end
