class FacebookCountCrawlJob < ActiveJob::Base
  queue_as :default

  def initialize(*arguments)
    super(*arguments)
    @application = FacebookCountCrawlApplication.new
  end

  def perform(article_id)
    @application.crawl article_id
  end
end
