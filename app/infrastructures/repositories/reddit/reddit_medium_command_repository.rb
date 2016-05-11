module Reddit
  class RedditMediumCommandRepository
    def save_if_not_exists(reddit_medium)
      unless RedditMedium.exists?(reddit_article_id: reddit_medium.reddit_article_id, url: reddit_medium.url)
        reddit_medium.save
      end
    end
  end
end
