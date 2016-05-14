module Reddit
  class RedditCrawlTask
    def run
      RedditCategory.all.map { |category| RedditCrawlJob.perform_later category }
      # RedditCrawlApplication.new.crawl REDDIT_GIFS
    end
  end
end
