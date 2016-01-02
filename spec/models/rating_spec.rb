require 'rails_helper'

RSpec.describe Rating, type: :model do
  describe '#first' do
    let!(:rating) { create(:rating) }

    it '正常系' do
      expect(rating.hatena_bookmark_count).to eq 101
      expect(rating.facebook_count).to eq 102
      expect(rating.pocket_count).to eq 103
    end
  end

  describe '#create' do
    let!(:article) { create(:article) }

    it '正常系' do
      Rating.create(hatena_bookmark_count: 1, facebook_count: 2, pocket_count: 3, article_id: article.id)
      expect(Rating.first.hatena_bookmark_count).to eq 1
      expect(Rating.first.facebook_count).to eq 2
      expect(Rating.first.pocket_count).to eq 3
    end

    it 'デフォルト値' do
      Rating.create(article_id: article.id)
      expect(Rating.first.hatena_bookmark_count).to eq 0
      expect(Rating.first.facebook_count).to eq 0
      expect(Rating.first.pocket_count).to eq 0
    end
  end

  describe '#update' do
    let!(:rating) { create(:rating) }

    it '正常系' do
      rating.update(hatena_bookmark_count: 10)
      expect(Rating.first.hatena_bookmark_count).to eq 10
      expect(Rating.first.facebook_count).to eq 102
      expect(Rating.first.pocket_count).to eq 103
    end
  end

end
