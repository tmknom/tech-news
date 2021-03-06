# == Schema Information
#
# Table name: articles
#
#  id            :integer          not null, primary key
#  url           :string(255)      not null
#  title         :string(255)      not null
#  description   :string(255)      not null
#  bookmarked_at :datetime         not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_articles_on_url  (url) UNIQUE
#

require 'rails_helper'

RSpec.describe Article, type: :model do
  describe '参照系' do
    let!(:article) { create(:article) }

    it '#all' do
      expect(Article.all[0].url).to eq article.url
    end
    it '#first' do
      expect(Article.first.url).to eq article.url
    end
    it '#find_by' do
      expect(Article.find_by(title: article.title).url).to eq article.url
    end
    it '#where' do
      expect(Article.where('title = ?', article.title)[0].url).to eq article.url
    end
    it '#find' do
      expect(Article.find(article.id).url).to eq article.url
    end
  end

  describe 'insert系' do
    it '#save' do
      article = Article.new(url: 'http://test.save.com/', title: 'Google', description: '検索エンジンだよ', bookmarked_at: '2015/12/30 12:34:56')
      expect(article.new_record?).to be_truthy
      article.save
      expect(Article.first.url).to eq 'http://test.save.com/'
      expect(article.new_record?).to be_falsey
    end
    it '#save!' do
      article = Article.new(url: 'http://test.save!.com/', title: 'Google', description: '検索エンジンだよ', bookmarked_at: '2015/12/30 12:34:56')
      expect(article.new_record?).to be_truthy
      article.save!
      expect(Article.first.url).to eq 'http://test.save!.com/'
      expect(article.new_record?).to be_falsey
    end
    it '#create' do
      article = Article.create(url: 'http://test.create.com/', title: 'Google', description: '検索エンジンだよ', bookmarked_at: '2015/12/30 12:34:56')
      expect(Article.first.url).to eq 'http://test.create.com/'
      expect(article.url).to eq 'http://test.create.com/'
      expect(article.persisted?).to be_truthy
      expect(article.new_record?).to be_falsey
    end
    it '#create!' do
      article = Article.create!(url: 'http://test.create!.com/', title: 'Google', description: '検索エンジンだよ', bookmarked_at: '2015/12/30 12:34:56')
      expect(Article.first.url).to eq 'http://test.create!.com/'
      expect(article.url).to eq 'http://test.create!.com/'
      expect(article.persisted?).to be_truthy
      expect(article.new_record?).to be_falsey
    end
  end

  describe 'update系' do
    let(:article) { create(:article) }

    it '#save' do
      article.url = 'http://test.save.com/'
      article.save
      expect(Article.first.url).to eq 'http://test.save.com/'
      expect(Article.first.title).to eq article.title
    end
    it '#save!' do
      article.url = 'http://test.save!.com/'
      article.save!
      expect(Article.first.url).to eq 'http://test.save!.com/'
      expect(Article.first.title).to eq article.title
    end
    it '#update' do
      article.update(url: 'http://test.update.com/')
      expect(Article.first.url).to eq 'http://test.update.com/'
      expect(Article.first.title).to eq article.title
    end
    it '#update_attribute' do
      article.update_attribute(:url, 'http://test.update_attribute.com/')
      expect(Article.first.url).to eq 'http://test.update_attribute.com/'
      expect(Article.first.title).to eq article.title
    end
  end

  describe 'delete系' do
    let(:article) { create(:article) }

    it '#destroy' do
      article.destroy
      expect(Article.first).to eq nil
      expect(article.destroyed?).to be(true)
    end
    it '#delete_all' do
      Article.delete_all
      expect(Article.first).to eq nil
    end
  end

  describe '異常系' do
    let(:article) { build(:article) }

    it 'url がnilの場合' do
      article.url = nil
      expect { article.save }.to raise_error(ActiveRecord::StatementInvalid)
    end
    it 'title がnilの場合' do
      article.title = nil
      expect { article.save }.to raise_error(ActiveRecord::StatementInvalid)
    end
    it 'description がnilの場合' do
      article.description = nil
      expect { article.save }.to raise_error(ActiveRecord::StatementInvalid)
    end
    it 'url がユニークじゃない場合' do
      Article.create!(url: article.url, title: 'Google', description: '検索エンジンだよ', bookmarked_at: '2015/12/30 12:34:56')
      expect { article.save }.to raise_error(ActiveRecord::RecordNotUnique)
    end
    it 'bookmarked_at が日付じゃない場合' do
      article.bookmarked_at = 'invalid'
      expect { article.save }.to raise_error(ActiveRecord::StatementInvalid)
    end
  end

end
