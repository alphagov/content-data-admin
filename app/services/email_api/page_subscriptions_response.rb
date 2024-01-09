module EmailApi
  class PageSubscriptionsResponse
    def initialize(all_notify_count:, subscriber_list_count:)
      @all_notify_count = all_notify_count
      @subscriber_list_count = subscriber_list_count
    end

    attr_reader :all_notify_count, :subscriber_list_count
  end
end
