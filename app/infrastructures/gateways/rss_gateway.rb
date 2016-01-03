class RssGateway
  def get(url)
    raw_rss_string = curl url
    parse raw_rss_string
  end

  private

  def curl(url)
    `curl -s "#{url}"`
  end

  def parse(raw_rss_string)
    rss = SimpleRSS.parse raw_rss_string
    rss.items
  end
end
