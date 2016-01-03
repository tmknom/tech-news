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

class HatenaBookmarkCountCrawlApplication

  def initialize
    @hatena_bookmark_count_gateway = HatenaBookmarkCountGateway.new
    @article_query_repository = ArticleQueryRepository.new
    @rating_command_repository = RatingCommandRepository.new
  end

  def crawl(url)
    article_id = @article_query_repository.get_id_by_url url
    hatena_bookmark_count = @hatena_bookmark_count_gateway.get url
    @rating_command_repository.save_hatena_bookmark_count(article_id, hatena_bookmark_count)
  end
end
