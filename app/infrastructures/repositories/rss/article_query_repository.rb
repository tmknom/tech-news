module Rss
  class ArticleQueryRepository
    def refer(id)
      Article.find(id)
    end

    def list_ranking
      Article.eager_load(:rating).where('created_at > (CURDATE() - INTERVAL 1 DAY)').order(bookmarked_at: :desc).limit(30)
    end

    def list_today
      Article.where('created_at > (CURDATE() - INTERVAL 1 DAY)').order(bookmarked_at: :desc).limit(30)
    end

    def list_week
      Article.where('created_at > (CURDATE() - INTERVAL 7 DAY)').order(bookmarked_at: :desc).limit(30)
    end

    def list_recent_id
      Article.order(bookmarked_at: :desc).limit(30).ids
    end
  end
end
