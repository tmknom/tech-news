require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do

  describe 'GET #index' do
    before do
      get :index
    end

    it 'ステータスコードとして200が返ること' do
      expect(response.status).to eq 200
    end
  end

end
