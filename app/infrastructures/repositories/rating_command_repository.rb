class RatingCommandRepository
  def save_if_not_exists(article_id)
    unless Rating.exists?(article_id: article_id)
      Rating.create(article_id: article_id, hatena_bookmark_count: 0, facebook_count: 0, pocket_count: 0)
    end
  end

  def save_hatena_bookmark_count(article_id, hatena_bookmark_count)
    rating = Rating.find_by(article_id: article_id)
    rating.update(hatena_bookmark_count: hatena_bookmark_count)
  end
end