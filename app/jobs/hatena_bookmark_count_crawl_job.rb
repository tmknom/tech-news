class HatenaBookmarkCountCrawlJob < ActiveJob::Base
  queue_as :default

  def initialize(*arguments)
    super(*arguments)
    @application = HatenaBookmarkCountCrawlApplication.new
  end

  def perform(article_id)
    @application.crawl article_id
  end
end
