module Reddit
  class RedditArticleQueryRepository
    def list_today
      RedditArticle.joins('INNER JOIN `media` ON `media`.`source_url` = `reddit_articles`.`url`').select('*').where('`reddit_articles`.`created_at` > (CURDATE() - INTERVAL 1 DAY)').order(posted_at: :desc).limit(30)
    end
  end
end
