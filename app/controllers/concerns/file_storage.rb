module FileStorage
  def upload_csv_to_s3(basename, body)
    connection = Fog::Storage.new(
      provider: "AWS",
      use_iam_profile: true,
      region: ENV["AWS_REGION"],
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
