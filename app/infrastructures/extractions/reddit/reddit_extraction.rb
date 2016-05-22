module Reddit
  class RedditExtraction
    API_PARAMS = {
        limit: 100,
        t: :day,
    }

    def initialize
      @client = Redd.it(:script, ENV['REDDIT_CLIENT_ID'], ENV['REDDIT_SECRET'], ENV['REDDIT_USER_NAME'], ENV['REDDIT_PASSWORD'])
      @client.authorize!
    end

    def extract(sub_reddit)
      @client.get_top(sub_reddit, API_PARAMS)
    end
  end
end
