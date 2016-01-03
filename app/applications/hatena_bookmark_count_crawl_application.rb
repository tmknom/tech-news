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