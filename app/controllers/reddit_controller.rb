class RedditController < ApplicationController
  def index
    @reddit_articles = Reddit::RedditArticleQueryRepository.new.list_today
    respond_to do |format|
      format.html
      format.json {
        render json: @reddit_articles.map {
                   |reddit_article| {
                     id: reddit_article.id,
                     url: reddit_article.url,
                     title: reddit_article.title,
                     posted_at: reddit_article.posted_at,
                     media_url: reddit_article.reddit_medium.url,
                     category: reddit_article.reddit_medium.category,
                 }
               }
      }
      # render :index
    end
  end
end
