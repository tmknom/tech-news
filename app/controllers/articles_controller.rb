class ArticlesController < ApplicationController
  def index
    articles = ArticleQueryRepository.new.list_week
    render json: articles
  end
end
