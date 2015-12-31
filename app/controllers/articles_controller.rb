class ArticlesController < ApplicationController
  def index
    article = Article.new(url: 'http://test.save.com/', title: 'Google', description: '検索エンジンだよ', bookmark_date_time: '2015/12/30 12:34:56')
    render json: article
  end
end
