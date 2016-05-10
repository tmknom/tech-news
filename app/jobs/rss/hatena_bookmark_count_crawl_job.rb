module Rss
  class HatenaBookmarkCountCrawlJob < ActiveJob::Base
    queue_as QueueName::RATING

    def initialize(*arguments)
      super(*arguments)
      @application = HatenaBookmarkCountCrawlApplication.new
    end

    def perform(article_id)
      @application.crawl article_id
    end
  end
end
