class FacebookCountCrawlJob < ActiveJob::Base
  queue_as :default

  def initialize
    super
    @article_query_repository = ArticleQueryRepository.new
    @facebook_count_crawl_application = FacebookCountCrawlApplication.new
  end

  # FacebookCountCrawlJob.perform_later
  def perform
    urls = @article_query_repository.list_recent_url
    urls.each do |url|
      @facebook_count_crawl_application.crawl url
    end
  end
end
