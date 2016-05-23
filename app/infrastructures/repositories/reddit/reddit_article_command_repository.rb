module Reddit
  class RedditArticleCommandRepository
    def save_if_not_exists(reddit_article)
      selected_reddit_article = RedditArticle.find_by(url: reddit_article.url)
      if selected_reddit_article.nil?
        reddit_article.save
      else
        selected_reddit_article.update(score: reddit_article.score, comment_count: reddit_article.comment_count)
      end
    end
  end
end
