module Reddit
  class RedditCrawlTask
    def run
      RedditCrawlJob.perform_later RedditCategory::FUNNY
      RedditCrawlJob.perform_later RedditCategory::GIFS
      # RedditCrawlApplication.new.crawl REDDIT_GIFS
    end
  end
end
