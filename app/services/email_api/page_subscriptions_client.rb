module EmailApi
  class PageSubscriptionsClient
    def initialize
      @email_alert_api = GdsApi::EmailAlertApi.new(Plek.find("email-alert-api"))
    end

    def fetch(path:)
      response = email_alert_api.get_subscriber_list_metrics(path:)
      EmailApi::PageSubscriptionsResponse.new(**response.to_h.symbolize_keys)
    rescue GdsApi::HTTPNotFound
      nil
    end

  private

    attr_reader :email_alert_api
  end
end
