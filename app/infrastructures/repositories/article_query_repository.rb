class ArticleQueryRepository
  def refer(id)
    Article.find(id)
  end

  def list_recent_id
    Article.order(bookmarked_at: :desc).limit(3).ids
  end
end