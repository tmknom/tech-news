class HatenaBookmarkCountCrawlTask
  def initialize
    @article_query_repository = Rss::ArticleQueryRepository.new
  end

  def run
    article_ids = @article_query_repository.list_recent_id
    article_ids.each do |article_id|
      HatenaBookmarkCountCrawlJob.perform_later article_id
    end
  end
end
