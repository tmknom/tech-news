module Reddit
  class RedditCrawlJob < ActiveJob::Base
    queue_as QueueName::RSS

    def perform(category)
      RedditCrawlApplication.new.crawl category
    end
  end
end
