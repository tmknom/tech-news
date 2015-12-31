require 'rails_helper'

RSpec.describe Article, type: :model do
  describe '参照系' do
    before do
      @article = Article.new(url: 'https://www.google.co.jp/', title: 'Google', description: '検索エンジンだよ', bookmark_date_time: '2015/12/30 12:34:56')
      @article.save
    end

    it '#all' do
      expect(Article.all[0].url).to eq @article.url
    end
    it '#first' do
      expect(Article.first.url).to eq @article.url
    end
    it '#find_by' do
      expect(Article.find_by(title: 'Google').url).to eq @article.url
    end
    it '#where' do
      expect(Article.where('title = ?', 'Google')[0].url).to eq @article.url
    end
    it '#find' do
      expect(Article.find(@article.id).url).to eq @article.url
    end
  end

  describe 'insert系' do
    it '#save' do
      article = Article.new(url: 'http://test.save.com/', title: 'Google', description: '検索エンジンだよ', bookmark_date_time: '2015/12/30 12:34:56')
      expect(article.new_record?).to be(true)
      article.save
      expect(Article.first.url).to eq 'http://test.save.com/'
      expect(article.new_record?).to be(false)
    end
    it '#save!' do
      article = Article.new(url: 'http://test.save!.com/', title: 'Google', description: '検索エンジンだよ', bookmark_date_time: '2015/12/30 12:34:56')
      expect(article.new_record?).to be(true)
      article.save!
      expect(Article.first.url).to eq 'http://test.save!.com/'
      expect(article.new_record?).to be(false)
    end
    it '#create' do
      article = Article.create(url: 'http://test.create.com/', title: 'Google', description: '検索エンジンだよ', bookmark_date_time: '2015/12/30 12:34:56')
      expect(Article.first.url).to eq 'http://test.create.com/'
      expect(article.url).to eq 'http://test.create.com/'
      expect(article.persisted?).to be(true)
      expect(article.new_record?).to be(false)
    end
    it '#create!' do
      article = Article.create!(url: 'http://test.create!.com/', title: 'Google', description: '検索エンジンだよ', bookmark_date_time: '2015/12/30 12:34:56')
      expect(Article.first.url).to eq 'http://test.create!.com/'
      expect(article.url).to eq 'http://test.create!.com/'
      expect(article.persisted?).to be(true)
      expect(article.new_record?).to be(false)
    end
  end

  describe 'update系' do
    before do
      @article = Article.create(url: 'http://test.before.com/', title: 'Google', description: '検索エンジンだよ', bookmark_date_time: '2015/12/30 12:34:56')
    end
    it '#save' do
      @article.url = 'http://test.save.com/'
      @article.save
      expect(Article.first.url).to eq 'http://test.save.com/'
      expect(Article.first.title).to eq 'Google'
    end
    it '#save!' do
      @article.url = 'http://test.save!.com/'
      @article.save
      expect(Article.first.url).to eq 'http://test.save!.com/'
      expect(Article.first.title).to eq 'Google'
    end
    it '#update' do
      @article.update(url: 'http://test.update.com/')
      expect(Article.first.url).to eq 'http://test.update.com/'
      expect(Article.first.title).to eq 'Google'
    end
    it '#update_attribute' do
      @article.update_attribute(:url, 'http://test.update_attribute.com/')
      expect(Article.first.url).to eq 'http://test.update_attribute.com/'
      expect(Article.first.title).to eq 'Google'
    end
  end

  describe 'delete系' do
    before do
      @article = Article.create(url: 'http://test.before.com/', title: 'Google', description: '検索エンジンだよ', bookmark_date_time: '2015/12/30 12:34:56')
    end

    it '#destroy' do
      @article.destroy
      expect(Article.first).to eq nil
      expect(@article.destroyed?).to be(true)
    end
    it '#delete_all' do
      Article.delete_all
      expect(Article.first).to eq nil
    end
  end

  describe '異常系' do
    before do
      @article = Article.new(url: 'https://www.google.co.jp/', title: 'Google', description: '検索エンジンだよ', bookmark_date_time: '2015/12/30 12:34:56')
    end
    it 'url がnilの場合' do
      @article.url = nil
      expect { @article.save }.to raise_error(ActiveRecord::StatementInvalid)
    end
    it 'title がnilの場合' do
      @article.title = nil
      expect { @article.save }.to raise_error(ActiveRecord::StatementInvalid)
    end
    it 'description がnilの場合' do
      @article.description = nil
      expect { @article.save }.to raise_error(ActiveRecord::StatementInvalid)
    end
    it 'url がユニークじゃない場合' do
      Article.create!(url: 'https://www.google.co.jp/', title: 'Google', description: '検索エンジンだよ', bookmark_date_time: '2015/12/30 12:34:56')
      expect { @article.save }.to raise_error(ActiveRecord::RecordNotUnique)
    end
    it 'bookmark_date_time が日付じゃない場合' do
      @article.bookmark_date_time = 'invalid'
      expect { @article.save }.to raise_error(ActiveRecord::StatementInvalid)
    end
  end

end
