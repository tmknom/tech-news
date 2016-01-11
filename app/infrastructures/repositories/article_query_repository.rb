class ArticleQueryRepository
  def refer(id)
    Article.find(id)
  end

  def list_recent_id
    Article.order(bookmarked_at: :desc).limit(30).ids
  end
end
