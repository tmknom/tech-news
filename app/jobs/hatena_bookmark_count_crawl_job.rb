class HatenaBookmarkCountCrawlJob < ActiveJob::Base
  queue_as :default

  def initialize
    super
    @article_query_repository = ArticleQueryRepository.new
    @application = HatenaBookmarkCountCrawlApplication.new
  end

  # HatenaBookmarkCountCrawlJob.perform_later
  def perform
    p "start #{self.class}"
    ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)
    urls = @article_query_repository.list_recent_url
    urls.each do |url|
      @application.crawl url
    end
    p "end #{self.class}"
  end
end
