class RedditController < ApplicationController
  def index
    # @reddit_articles = Reddit::RedditArticleQueryRepository.new.list_today

    @reddit_articles = Reddit::RedditArticle.joins(:reddit_medium).eager_load(:reddit_medium).where('reddit_articles.created_at > (CURDATE() - INTERVAL 1 DAY)').order(posted_at: :desc).page(params[:page])
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
                     media_type: reddit_article.reddit_medium.media_type,
                 }
               }
      }
      # render :index
    end
  end
end
