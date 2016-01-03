class FacebookCountCrawlApplication
  def initialize
    @facebook_count_gateway = FacebookCountGateway.new
    @article_query_repository = ArticleQueryRepository.new
    @rating_command_repository = RatingCommandRepository.new
  end

  def crawl(url)
    article_id = @article_query_repository.get_id_by_url url
    facebook_count = @facebook_count_gateway.get url
    @rating_command_repository.save_facebook_count(article_id, facebook_count)
  end
end