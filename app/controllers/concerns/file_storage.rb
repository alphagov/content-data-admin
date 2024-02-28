module FileStorage
  def upload_csv_to_s3(basename, body)
    s3 = Aws::S3::Client.new

    timestamp = Time.zone.now.utc.strftime("%Y-%m-%d-%H-%M-%S")
    filename = "#{basename}.csv"
    key = "#{timestamp}/#{filename}"

    s3.put_object({
      acl: "public-read",
      body:,
      bucket: ENV["AWS_CSV_EXPORT_BUCKET_NAME"],
      content_disposition: "attachment; filename=\"#{filename}\"",
      content_type: "text/csv",
      key:,
    })

    "https://#{ENV['AWS_CSV_EXPORT_BUCKET_NAME']}.s3.amazonaws.com/#{key}"
  end
end
