module Reddit
  class RedditCrawlApplication
    def initialize
      @rss_gateway = Rss::RssGateway.new
      @reddit_rss_transformation = RedditRssTransformation.new
      @reddit_article_command_repository = RedditArticleCommandRepository.new
      @reddit_medium_command_repository = RedditMediumCommandRepository.new
    end

    def crawl(category)
      rss_url = rss_url category
      rss_items = @rss_gateway.get rss_url
      rss_items.each do |rss_item|
        save_rss_item rss_item, category
      end
    end

    private

    def rss_url(category)
      "https://www.reddit.com/r/#{category}/hot/.rss".freeze
    end

    def save_rss_item(rss_item, category)
      begin
        reddit_article = @reddit_rss_transformation.transform rss_item, category
        @reddit_article_command_repository.save_if_not_exists reddit_article

        reddit_medium = @reddit_rss_transformation.transform_medium reddit_article.id, rss_item
        @reddit_medium_command_repository.save_if_not_exists reddit_medium
      rescue => e
        # todo ログ吐いたほうがいい
        # 例外が発生しても次の記事はそのまま処理して欲しいので、とりあえず標準出力して、処理を継続する
        p e.message
      end
    end
  end
end
