module Reddit
  module RedditCategory
    GIFS = 'gifs'
    FUNNY = 'funny'
    AWW = 'aww'
    PICS = 'pics'

    def self.all
      constants.map { |e| const_get(e) }
    end
  end
end
