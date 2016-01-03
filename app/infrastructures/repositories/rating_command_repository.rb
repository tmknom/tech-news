class RatingCommandRepository
  def save_if_not_exists(article_id)
    unless Rating.exists?(article_id: article_id)
      Rating.create(article_id: article_id, hatena_bookmark_count: 0, facebook_count: 0, pocket_count: 0)
    end
  end
end