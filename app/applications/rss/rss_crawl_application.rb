module Rss
  class RssCrawlApplication
    def initialize
      @rss_gateway = RssGateway.new
      @rss_transformation = RssTransformation.new
      @article_command_repository = ArticleCommandRepository.new
      @rating_command_repository = RatingCommandRepository.new
    end

    def crawl(url)
      rss_items = @rss_gateway.get url
      rss_items.each do |rss_item|
        save_rss_item rss_item
      end
    end

    private

    def save_rss_item(rss_item)
      begin
        article = @rss_transformation.transform rss_item
        @article_command_repository.save_if_not_exists article
        @rating_command_repository.save_if_not_exists article.id
      rescue => e
        # todo ログ吐いたほうがいい
        # 例外が発生しても次の記事はそのまま処理して欲しいので、とりあえず標準出力して、処理を継続する
        p e.message
      end
    end
  end
end
