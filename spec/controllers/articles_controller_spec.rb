require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do

  describe 'GET #index' do
    before do
      get :index
      @article = Article.new(url: 'http://test.save.com/', title: 'Google', description: '検索エンジンだよ', bookmark_date_time: '2015/12/30 12:34:56')
    end

    it 'ステータスコードとして200が返ること' do
      expect(response.status).to eq 200
    end

    it 'レスポンスJSONが正しいこと' do
      json = JSON.parse(response.body)
      expect(json['url']).to eq @article.url
      expect(json['title']).to eq @article.title
      expect(json['description']).to eq @article.description
    end
  end

end
