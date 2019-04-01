require 'active_support/concern'
require 'gds_api/content_data_api'

module Concerns::ContentDataApiClient
  extend ActiveSupport::Concern

  included do
    def api
      @api ||= GdsApi::ContentDataApi.new
    end
  end
end
