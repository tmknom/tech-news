class FacebookCountGateway
  require 'open-uri'
  require 'json'

  FACEBOOK_COUNT_URL = 'http://graph.facebook.com/?id='.freeze

  def get(url)
    raw_body = open(FACEBOOK_COUNT_URL + url).read
    json = JSON.parse(raw_body)
    json.has_key?('shares') ? json['shares'].to_i : 0
  end
end