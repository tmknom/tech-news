class RedditCrawlApplication
  def initialize
    @rss_gateway = RssGateway.new
    @reddit_rss_converter = RedditRssConverter.new
    @article_command_repository = ArticleCommandRepository.new
    @rating_command_repository = RatingCommandRepository.new
  end

  def crawl(url)
    rss_items = @rss_gateway.get url
    rss_items.each do |rss_item|
      save_rss_item rss_item
      break
    end
  end

  private

  def save_rss_item(rss_item)
    begin
      article = @reddit_rss_converter.convert rss_item
      puts article
      # @article_command_repository.save_if_not_exists article
      # @rating_command_repository.save_if_not_exists article.id
    rescue => e
      # todo ログ吐いたほうがいい
      # 例外が発生しても次の記事はそのまま処理して欲しいので、とりあえず標準出力して、処理を継続する
      p e.message
    end
  end
end

class RedditRssConverter
  def convert(rss_item)
    title = rss_item.title.force_encoding('utf-8')
    url = rss_item.link.force_encoding('utf-8')
    description = rss_item.content.force_encoding('utf-8')
    created_at = rss_item.updated.in_time_zone('Tokyo') # Time型
    { Title: title, URL: url, Created: created_at, Description: description }
    # Article.new(url: url, title: title, description: description, bookmarked_at: bookmarked_at)
  end
end
