module Reddit
  class RedditArticleQueryRepository
    def list_today
      RedditArticle.where('created_at > (CURDATE() - INTERVAL 1 DAY)').order(posted_at: :desc).limit(30)
    end
  end
end
