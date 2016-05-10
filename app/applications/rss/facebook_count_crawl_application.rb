module Rss
  class FacebookCountCrawlApplication
    def initialize
      @facebook_count_gateway = FacebookCountGateway.new
      @article_query_repository = Rss::ArticleQueryRepository.new
      @rating_command_repository = RatingCommandRepository.new
    end

    def crawl(article_id)
      article = @article_query_repository.refer article_id
      facebook_count = get_facebook_count article.url
      @rating_command_repository.save_facebook_count(article_id, facebook_count)
    end

    private

    def get_facebook_count(url)
      @facebook_count_gateway.get url
    end
  end
end
