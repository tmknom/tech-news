class RedditController < ApplicationController
  def index
    reddit_articles = Reddit::RedditArticleQueryRepository.new.list_today
    render json: reddit_articles
  end
end
