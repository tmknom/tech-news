require 'open-uri'

class HatenaBookmarkCountGateway
  HATENA_BOOKMARK_COUNT_URL = 'http://api.b.st-hatena.com/entry.count?url='.freeze

  def get(url)
    raw_body = open(HATENA_BOOKMARK_COUNT_URL + url).read
    raw_body.empty? ? '0' : raw_body.to_i
  end
end
