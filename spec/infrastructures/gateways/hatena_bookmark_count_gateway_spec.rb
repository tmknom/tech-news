require 'rails_helper'

RSpec.describe HatenaBookmarkCountGateway, type: :model do

  describe '#get' do
    let!(:hatena_bookmark_count_gateway) { HatenaBookmarkCountGateway.new }

    it '正常系' do
      url = 'http://www.yahoo.co.jp/'
      VCR.use_cassette 'hatena_bookmark_count/www.yahoo.co.jp' do
        hatena_bookmark_count = hatena_bookmark_count_gateway.get url
        expect(hatena_bookmark_count).to eq 13816
      end
    end
  end

end
