module Reddit
  class RedditArticleQueryRepository
    PER_PAGE = 50
    DEFAULT_SCORE = 100

    def list_recently(score, page)
      score = score_or_default(score)
      where = "reddit_articles.created_at > (CURDATE() - INTERVAL 30 HOUR) and score > #{score}"
      list(where, page)
    end

    private

    def list(where, page)
      RedditArticle.joins(:reddit_medium).eager_load(:reddit_medium)
          .where(where)
          .order(score: :desc)
          .page(page).per(PER_PAGE)
    end

    def score_or_default(score)
      if score.blank?
        return DEFAULT_SCORE
      end
      score
    end
  end
end
