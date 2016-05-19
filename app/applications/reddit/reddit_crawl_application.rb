module Reddit
  class RedditCrawlApplication
    def initialize
      @reddit_extraction = RedditExtraction.new
      @reddit_api_transformation = RedditApiTransformation.new
      @reddit_article_command_repository = RedditArticleCommandRepository.new
      @reddit_medium_command_repository = RedditMediumCommandRepository.new
    end

    def crawl(category)
      items = @reddit_extraction.extract category
      items.each do |item|
        quiet_save_item item, category
      end
    end

    private

    def quiet_save_item(item, category)
      begin
        save_item(item, category)
      rescue => e
        # todo ログ吐いたほうがいい
        # 例外が発生しても次の記事はそのまま処理して欲しいので、とりあえず標準出力して、処理を継続する
        p e.message
      end
    end

    def save_item(item, category)
      reddit_article = @reddit_api_transformation.transform item, category
      if reddit_article.popular?
        @reddit_article_command_repository.save_if_not_exists reddit_article
        save_reddit_medium(reddit_article.id, item)
      end

    end

    def save_reddit_medium(reddit_article_id, item)
      unless reddit_article_id.nil?
        reddit_medium = @reddit_api_transformation.transform_medium reddit_article_id, item
        @reddit_medium_command_repository.save_if_not_exists reddit_medium
      end
    end
  end
end
