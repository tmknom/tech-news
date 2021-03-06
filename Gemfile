source 'https://rubygems.org'

### 追加インストール
gem 'unicorn' # アプリケーションサーバ
gem 'foreman' # プロセス
gem 'whenever', :require => false # crontab管理
gem 'sidekiq' # 非同期処理
gem 'simple-rss', '~> 1.3', '>= 1.3.1' # RSSパーサ
gem 'awesome_print' # Rubyオブジェクトを綺麗に整形
gem 'bootstrap-sass', '~> 3.3', '>= 3.3.6' # Twitter Bootstrap
gem 'kaminari' # ページャ
gem 'redd', '~> 0.7.0' # reddit クライアント
gem 'rumoji' # 絵文字をhuman readableに変更（MySQLに保存できるよう対策/utf8mb4にすれば不要）

group :test do
  # テスト
  gem 'rspec-rails', '~> 3.0' # rails対応のrspec
  gem 'factory_girl_rails' # Fixtureを簡単に定義できるようにする
  gem 'webmock' # HTTP通信をモック化する
  gem 'vcr' # 一回目のHTTP通信から自動的にFixtureを作成し、二回目以降はFixtureを参照する
  gem 'coveralls', require: false # カバレッジ取得サービス用(https://coveralls.io/)
end

group :development do
  # コマンド高速化
  gem 'spring-commands-rspec' # rspecの実行高速化
  gem 'spring-commands-cucumber' # cucumberの実行高速化

  # デバッガ
  gem 'pry-rails' # rails cをirbからpryに変更
  gem 'pry-byebug' # pryでステップ実行できるようにする

  # ログなどの表示整形
  gem 'better_errors' # 開発中のエラー画面をわかりやすくする
  gem 'hirb' # モデルの出力結果を表形式に整形
  gem 'hirb-unicode' # hirbの日本語出力をずれないようにする
  gem 'rails-flog', require: 'flog' # SQLやHashを綺麗に整形

  # 開発効率化
  gem 'annotate'
end

### Rails 自動生成

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.3.13', '< 0.5'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

