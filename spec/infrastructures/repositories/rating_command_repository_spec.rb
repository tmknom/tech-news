# == Schema Information
#
# Table name: ratings
#
#  id                    :integer          not null, primary key
#  article_id            :integer          not null
#  hatena_bookmark_count :integer          default(0), not null
#  facebook_count        :integer          default(0), not null
#  pocket_count          :integer          default(0), not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_ratings_on_article_id  (article_id)
#
# Foreign Keys
#
#  fk_rails_e25201a524  (article_id => articles.id)
#

require 'rails_helper'

RSpec.describe RatingCommandRepository, type: :model do

  let(:rating_command_repository) { RatingCommandRepository.new }

  describe '#save_if_not_exists' do

    it 'DBにデータが存在しないので保存する' do
      article = create(:article)

      # DBに一件もデータがないことを確認
      expect(Rating.all.size).to eq 0
      # 実行
      rating_command_repository.save_if_not_exists article.id
      # DBに初期値が登録されたことを確認
      expect(Rating.all.size).to eq 1
      expect(Rating.first.article_id).to eq article.id
      expect(Rating.first.hatena_bookmark_count).to eq 0
      expect(Rating.first.facebook_count).to eq 0
      expect(Rating.first.pocket_count).to eq 0
    end

    it 'DBにデータが存在するので保存しない' do
      rating = create(:rating)

      # DBにテストデータが一件だけ登録されていることを確認
      expect(Rating.all.size).to eq 1
      expect(Rating.first.article_id).to eq rating.article_id
      expect(Rating.first.hatena_bookmark_count).to eq rating.hatena_bookmark_count
      expect(Rating.first.facebook_count).to eq rating.facebook_count
      expect(Rating.first.pocket_count).to eq rating.pocket_count
      # 実行
      rating_command_repository.save_if_not_exists rating.article_id
      # DBに登録されたテストデータに変更がないことを確認
      expect(Rating.all.size).to eq 1
      expect(Rating.first.article_id).to eq rating.article_id
      expect(Rating.first.hatena_bookmark_count).to eq rating.hatena_bookmark_count
      expect(Rating.first.facebook_count).to eq rating.facebook_count
      expect(Rating.first.pocket_count).to eq rating.pocket_count
    end
  end

  describe '#save_hatena_bookmark_count' do
    let!(:rating) { create(:rating) }

    it '正常系' do
      # 変更前のデータを確認
      expect(Rating.first.hatena_bookmark_count).to eq rating.hatena_bookmark_count
      # 実行
      rating_command_repository.save_hatena_bookmark_count(rating.article_id, 999)
      # 変更後のデータを確認
      expect(Rating.first.hatena_bookmark_count).to eq 999
    end
  end

  describe '#save_facebook_count' do
    let!(:rating) { create(:rating) }

    it '正常系' do
      # 変更前のデータを確認
      expect(Rating.first.facebook_count).to eq rating.facebook_count
      # 実行
      rating_command_repository.save_facebook_count(rating.article_id, 999)
      # 変更後のデータを確認
      expect(Rating.first.facebook_count).to eq 999
    end
  end

end
