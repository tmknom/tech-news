module Reddit
  class RedditArticleQueryRepository
    PER_PAGE = 50

    def list_recently(page)
      where = 'reddit_articles.created_at > (CURDATE() - INTERVAL 7 DAY)'
      list(where, page)
    end

    private

    def list(where, page)
      RedditArticle.joins(:reddit_medium).eager_load(:reddit_medium)
          .where(where)
          .order(created_at: :desc)
          .page(page).per(PER_PAGE)
    end
  end
end
