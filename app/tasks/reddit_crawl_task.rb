class RedditCrawlTask
  def run
    RedditCrawlJob.perform_later RssUrl::REDDIT_GIFS
    # RedditCrawlApplication.new.crawl RssUrl::REDDIT_GIFS
  end
end

module RssUrl
  REDDIT_GIFS = 'https://www.reddit.com/r/gifs/top/.rss'.freeze
end
