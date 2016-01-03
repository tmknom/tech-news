class ArticleCommandRepository
  def save_if_not_exists(article)
    unless Article.exists?(url: article.url)
      article.save
    end
  end
end