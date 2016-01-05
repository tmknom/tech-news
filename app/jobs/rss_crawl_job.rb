class RssCrawlJob < ActiveJob::Base
  queue_as :default

  def perform(url)
    RssCrawlApplication.new.crawl url
  end
end
