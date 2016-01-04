require 'rails_helper'

RSpec.describe FacebookCountGateway, type: :model do

  describe '#get' do
    let!(:facebook_count_gateway) { FacebookCountGateway.new }

    it '正常系' do
      url = 'http://www.yahoo.co.jp/'
      VCR.use_cassette 'facebook_count/www.yahoo.co.jp' do
        facebook_count = facebook_count_gateway.get url
        expect(facebook_count).to eq 275258
      end
    end
  end

end
