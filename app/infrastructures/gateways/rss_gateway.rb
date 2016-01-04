class RssGateway
  def get(url)
    raw_rss_string = curl url
    parse raw_rss_string
  end

  private

  def curl(url)
    require 'open-uri'
    open(url, 'User-Agent' => FAKE_USER_AGENT).read
  end

  def parse(raw_rss_string)
    rss = SimpleRSS.parse raw_rss_string
    rss.items
  end

  # はてブはユーザエージェントがrubyだと弾かれるので偽装しておく
  FAKE_USER_AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_5) AppleWebKit/537.36 (KHTML, like Gecko)'.freeze
end
