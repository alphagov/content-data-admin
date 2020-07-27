module FileStorage
  def upload_csv_to_s3(basename, body)
    connection = Fog::Storage.new(
      provider: "AWS",
      region: ENV["AWS_REGION"],
      aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
      aws_secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
    )

    directory = connection.directories.get(ENV["AWS_CSV_EXPORT_BUCKET_NAME"])

    timestamp = Time.zone.now.utc.strftime("%Y-%m-%d-%H-%M-%S")
    filename = "#{basename}.csv"
    key = "#{timestamp}/#{filename}"

    file = directory.files.create(
      key: key,
      body: body,
      public: true,
      content_disposition: "attachment; filename=\"#{filename}\"",
      content_type: "text/csv",
    )

    file.public_url
  end
end
