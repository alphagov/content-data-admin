require "active_support/concern"

module Concerns::ExportableToCSV
  extend ActiveSupport::Concern

  included do
    def export_to_csv(enum:, filename: "download.csv")
      set_file_headers(filename)
      set_streaming_headers

      response.status = 200
      self.response_body = enum
    end

  private

    def set_file_headers(filename)
      headers["Content-Type"] = "text/csv"
      headers["Content-disposition"] = "attachment; filename=\"#{filename}\""
    end

    def set_streaming_headers
      # nginx doc: Setting this to "no" will allow unbuffered responses suitable for Comet and HTTP streaming applications
      headers["X-Accel-Buffering"] = "no"

      headers["Cache-Control"] ||= "no-cache"
      headers.delete("Content-Length")
    end
  end
end
