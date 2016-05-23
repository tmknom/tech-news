require 'rails_helper'

RSpec.describe Reddit::RedditExtraction, type: :model do

  describe '#get' do
    # let!(:reddit_extraction) { Reddit::RedditExtraction.new }

    it '正常系' do
      VCR.use_cassette 'reddit/www.reddit.com' do
        articles = Reddit::RedditExtraction.new.extract('gifs')

        expect(articles.size).to eq 11
        expect(articles[0].title).to eq '/r/Gifs rules: Please read before submitting or commenting'
      end
    end
  end

end
