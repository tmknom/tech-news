class FacebookCountCrawlTask
  def initialize
    @article_query_repository = ArticleQueryRepository.new
  end

  def run
    article_ids = @article_query_repository.list_recent_id
    article_ids.each do |article_id|
      FacebookCountCrawlJob.perform_later article_id
    end
  end
end