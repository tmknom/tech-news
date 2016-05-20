require 'rails_helper'

RSpec.describe RedditController, type: :controller do

  describe 'GET #index' do
    before do
      get :index
    end

    it 'ステータスコードとして200が返ること' do
      expect(response.status).to eq 200
    end
  end

  describe 'GET #log' do
    before do
      get :log
    end

    it 'ステータスコードとして200が返ること' do
      expect(response.status).to eq 200
    end
  end

end
