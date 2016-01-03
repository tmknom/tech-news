class RssCrawlApplication
  def initialize
    @rss_gateway = RssGateway.new
    @article_rss_converter = ArticleRssConverter.new
    @article_command_repository = ArticleCommandRepository.new
    @rating_command_repository = RatingCommandRepository.new
  end

  def crawl(url)
    rss_items = @rss_gateway.get url
    rss_items.each do |rss_item|
      article = @article_rss_converter.convert rss_item
      @article_command_repository.save_if_not_exists article
      @rating_command_repository.save_if_not_exists article.id
    end
  end
end

class ArticleRssConverter
  def convert(rss_item)
    title = rss_item.title.force_encoding('utf-8')
    url = rss_item.link.force_encoding('utf-8')
    description = rss_item.description.force_encoding('utf-8')
    bookmarked_at = rss_item.dc_date.in_time_zone('Tokyo') # Time型
    Article.new(url: url, title: title, description: description, bookmarked_at: bookmarked_at)
  end
end
