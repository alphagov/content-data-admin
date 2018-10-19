class FetchDocumentTypes
  include MetricsCommon
  def self.call
    new.call
  end

  def call
    api.document_types
  end
end
