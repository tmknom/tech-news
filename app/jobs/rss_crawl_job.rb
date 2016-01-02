class RssCrawlJob < ActiveJob::Base
  queue_as :default

  HATENA_BOOKMARK_RSS_URL = 'http://b.hatena.ne.jp/entrylist/it?sort=hot&threshold=30&mode=rss'.freeze

  # RssCrawlJob.perform_later
  def perform
    p "start #{self.class}"
    RssCrawlApplication.new.crawl HATENA_BOOKMARK_RSS_URL
    p "end #{self.class}"
  end
end

class RssCrawlApplication
  def initialize
    @curl_adapter = CurlAdapter.new
    @rss_parser = RssParser.new
    @article_rss_converter = ArticleRssConverter.new
    @article_repository = ArticleRepository.new
  end

  def crawl(url)
    raw_rss_string = @curl_adapter.curl url
    rss_items = @rss_parser.parse raw_rss_string
    rss_items.each do |rss_item|
      article = @article_rss_converter.convert rss_item
      @article_repository.save_if_not_exists article
    end
  end
end

class CurlAdapter
  def curl(url)
    `curl -s "#{url}"`
  end
end

class RssParser
  def parse(raw_rss_string)
    rss = SimpleRSS.parse raw_rss_string
    rss.items
  end
end

class ArticleRssConverter
  def convert(rss_item)
    title = rss_item.title.force_encoding('utf-8')
    url = rss_item.link.force_encoding('utf-8')
    description = rss_item.description.force_encoding('utf-8')
    bookmarked_at = rss_item.dc_date # Time型
    Article.new(url: url, title: title, description: description, bookmarked_at: bookmarked_at)
  end
end

class ArticleRepository
  def save_if_not_exists(article)
    unless Article.exists?(url: article.url)
      article.save
    end
  end
end

