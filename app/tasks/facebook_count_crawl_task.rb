class FacebookCountCrawlTask
  def initialize
    @article_query_repository = ArticleQueryRepository.new
  end

  def run
    urls = @article_query_repository.list_recent_url
    urls.each do |url|
      FacebookCountCrawlJob.perform_later url
    end
  end
end