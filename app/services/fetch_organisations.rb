class FetchOrganisations
  include MetricsCommon

  def self.call
    new.call
  end

  def call
    api.organisations
  end
end
