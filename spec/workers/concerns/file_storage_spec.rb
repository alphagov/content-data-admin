RSpec.describe "FileStorage" do
  include FileStorage
  describe "#upload_csv_to_s3" do
    before do
      Timecop.freeze(Time.new(2019, 5, 4, 3, 2, 1, "+00:00"))
      Fog.mock!

      ENV["AWS_REGION"] = "eu-west-1"
      ENV["AWS_ACCESS_KEY_ID"] = "test"
      ENV["AWS_SECRET_ACCESS_KEY"] = "test"
      ENV["AWS_CSV_EXPORT_BUCKET_NAME"] = "test-bucket"

      # Create an S3 bucket so the code being tested can find it
      connection = Fog::Storage.new(
        provider: "AWS",
        region: ENV["AWS_REGION"],
        aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
        aws_secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
      )
      @directory = connection.directories.create!(key: ENV["AWS_CSV_EXPORT_BUCKET_NAME"])
    end

    after do
      Fog::Mock.reset
      Timecop.return
    end

    it "uploads a file to s3" do
      upload_csv_to_s3("basename", "body")

      expect(@directory.files.first.key).to eq("2019-05-04-03-02-01/basename.csv")
      expect(@directory.files.first.body).to eq("body")
    end

    it "returns the public url" do
      url = upload_csv_to_s3("basename", "")

      expect(url).to eq("https://test-bucket.s3-eu-west-1.amazonaws.com/2019-05-04-03-02-01/basename.csv")
    end
  end
end
