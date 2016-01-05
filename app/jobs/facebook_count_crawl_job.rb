class FacebookCountCrawlJob < ActiveJob::Base
  queue_as :default

  def initialize(*arguments)
    super(*arguments)
    @application = FacebookCountCrawlApplication.new
  end

  # FacebookCountCrawlJob.perform_later url
  def perform(url)
    @application.crawl url
  end
end
