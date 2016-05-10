module Rss
  class RatingCommandRepository
    def save_if_not_exists(article_id)
      return if article_id.nil?

      unless Rating.exists?(article_id: article_id)
        Rating.create(article_id: article_id, hatena_bookmark_count: 0, facebook_count: 0, pocket_count: 0)
      end
    end

    def save_hatena_bookmark_count(article_id, hatena_bookmark_count)
      rating = Rating.find_by(article_id: article_id)
      rating.update(hatena_bookmark_count: hatena_bookmark_count)
    end

    def save_facebook_count(article_id, facebook_count)
      rating = Rating.find_by(article_id: article_id)
      rating.update(facebook_count: facebook_count)
    end
  end
end
