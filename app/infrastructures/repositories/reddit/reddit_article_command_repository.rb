module Reddit
  class RedditArticleCommandRepository
    def save_if_not_exists(reddit_article)
      unless RedditArticle.exists?(url: reddit_article.url)
        reddit_article.save
      end
    end
  end
end
