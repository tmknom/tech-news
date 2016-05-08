class RedditCrawlJob < ActiveJob::Base
  queue_as QueueName::RSS

  def perform(url)
    RedditCrawlApplication.new.crawl url
  end
end
