module Reddit
  class RedditArticleQueryRepository
    PER_PAGE = 50
    DEFAULT_SCORE = 100

    def list_recently(score, page)
      score = score_or_default(score)
      where = "reddit_articles.created_at > (CURDATE() - INTERVAL 24 HOUR) AND score > #{score}"
      list(where, page)
    end

    def list_by_date(date, score, page)
      date = date_or_default(date)
      score = score_or_default(score)
      where = "#{where_between_date('reddit_articles.created_at', date)} AND score > #{score}"
      list(where, page)
    end

    private

    def list(where, page)
      RedditArticle.joins(:reddit_medium).eager_load(:reddit_medium)
          .where(where)
          .order(score: :desc)
          .page(page).per(PER_PAGE)
    end

    def where_between_date(column_name, date)
      " #{column_name} >= '#{date} 00:00:00' AND #{column_name} < '#{date} 23:59:59' "
    end

    def date_or_default(date)
      if date.blank?
        return Date.today
      end
      date
    end

    def score_or_default(score)
      if score.blank?
        return DEFAULT_SCORE
      end
      score
    end
  end
end
