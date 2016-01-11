# tech-news

## セットアップ

```bash
git clone https://github.com/tmknom/tech-news.git
cd tech-news
bundle install --path vendor/bundle --without development
RAILS_ENV=production bundle exec rake db:migrate
```

## デプロイ

```bash
time fab deploy -u <user> -i ~/.ssh/aws/initialize.pem -H <ip_address>
```

## Rakeタスク

### バッチタスク

#### バッチタスク一覧

```bash
RAILS_ENV=production bundle exec rake batch:list
```

#### はてブのRSSを取得

```bash
RAILS_ENV=production bundle exec rake batch:rss_crawler:crawl
```

#### はてブ数を取得

```bash
RAILS_ENV=production bundle exec rake batch:rating_crawler:hatena_bookmark_count_crawl
```

#### イイネ数を取得

```bash
RAILS_ENV=production bundle exec rake batch:rating_crawler:facebook_count_crawl
```


### 運用タスク

#### 運用タスク一覧

```bash
RAILS_ENV=production bundle exec rake command:list
```

#### Sidekiqのジョブ一覧を表示

```bash
RAILS_ENV=production bundle exec rake command:sidekiq:show_all
```

#### Sidekiqのジョブ一覧を詳細表示

```bash
RAILS_ENV=production bundle exec rake command:sidekiq:show_verbose_all
```

#### Sidekiqのステータスを表示

```bash
RAILS_ENV=production bundle exec rake command:sidekiq:show_status
```

#### Sidekiqのジョブを全てクリア

```bash
RAILS_ENV=production bundle exec rake command:sidekiq:clear_all
```


## Webサーバの起動と終了

### 起動

```bash
RAILS_ENV=production bundle exec rails s -b 0.0.0.0 -d
```

### 終了

```bash
cat tmp/pids/server.pid | xargs kill -9
```


## Sidekiqの起動と終了

### 起動

```bash
RAILS_ENV=production bundle exec sidekiq -q default -q rss -q rating -L log/sidekiq.log -P tmp/pids/sidekiq.pid -d
```

### 終了

```bash
RAILS_ENV=production bundle exec sidekiqctl stop tmp/pids/sidekiq.pid
```

