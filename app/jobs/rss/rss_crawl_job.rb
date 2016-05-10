module Rss
  class RssCrawlJob < ActiveJob::Base
    queue_as QueueName::RSS

    def perform(url)
      RssCrawlApplication.new.crawl url
    end
  end
end
