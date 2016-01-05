class ArticleQueryRepository
  def refer(id)
    Article.find(id)
  end

  def get_id_by_url(url)
    Article.select(:id).find_by(url: url).id
  end

  def list_recent_url
    Article.order(bookmarked_at: :desc).limit(3).pluck(:url)
  end

  def list_recent_id
    Article.order(bookmarked_at: :desc).limit(3).ids
  end
end