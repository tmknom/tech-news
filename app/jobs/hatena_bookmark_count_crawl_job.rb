class HatenaBookmarkCountCrawlJob < ActiveJob::Base
  queue_as :default

  def initialize(*arguments)
    super(*arguments)
    @application = HatenaBookmarkCountCrawlApplication.new
  end

  # HatenaBookmarkCountCrawlJob.perform_later
  def perform(url)
    @application.crawl url
  end
end
