module Reddit
  class RedditCrawlApplication
    def initialize
      @rss_gateway = Rss::RssGateway.new
      @reddit_rss_transformation = RedditRssTransformation.new
      @reddit_article_command_repository = RedditArticleCommandRepository.new
      @media_command_repository = Media::MediaCommandRepository.new
    end

    def crawl(url)
      rss_items = @rss_gateway.get url
      rss_items.each do |rss_item|
        save_rss_item rss_item
      end
    end

    private

    def save_rss_item(rss_item)
      begin
        article = @reddit_rss_transformation.transform rss_item
        @reddit_article_command_repository.save_if_not_exists article

        medium = @reddit_rss_transformation.transform_medium rss_item
        @media_command_repository.save_if_not_exists medium
      rescue => e
        # todo ログ吐いたほうがいい
        # 例外が発生しても次の記事はそのまま処理して欲しいので、とりあえず標準出力して、処理を継続する
        p e.message
      end
    end
  end
end
