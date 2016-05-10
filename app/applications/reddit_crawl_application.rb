class RedditCrawlApplication
  def initialize
    @rss_gateway = RssGateway.new
    @reddit_rss_transformation = Reddit::RedditRssTransformation.new
    @reddit_article_command_repository = Reddit::RedditArticleCommandRepository.new
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
    rescue => e
      # todo ログ吐いたほうがいい
      # 例外が発生しても次の記事はそのまま処理して欲しいので、とりあえず標準出力して、処理を継続する
      p e.message
    end
  end
end
