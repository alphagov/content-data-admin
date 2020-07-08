class FetchOrganisations
  include ContentDataApiClient

  def self.call
    new.call
  end

  def call
    api.organisations
  end
end
