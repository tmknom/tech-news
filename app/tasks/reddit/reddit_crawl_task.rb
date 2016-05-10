module Reddit
  class RedditCrawlTask
    def run
      RedditCrawlJob.perform_later REDDIT_GIFS
      # RedditCrawlApplication.new.crawl REDDIT_GIFS
    end
  end

  REDDIT_GIFS = 'https://www.reddit.com/r/gifs/top/.rss'.freeze
end
