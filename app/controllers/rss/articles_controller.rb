module Rss
  class ArticlesController < ApplicationController
    def index
      articles = Rss::ArticleQueryRepository.new.list_week
      render json: articles
    end
  end
end
