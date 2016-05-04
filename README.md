# tech-news

[![Circle CI](https://circleci.com/gh/tmknom/tech-news.svg?style=svg)](https://circleci.com/gh/tmknom/tech-news)
[![Coverage Status](https://coveralls.io/repos/tmknom/tech-news/badge.svg?branch=feature%2Fsetting-circle-ci&service=github)](https://coveralls.io/github/tmknom/tech-news?branch=feature%2Fsetting-circle-ci)
[![Dependency Status](https://gemnasium.com/tmknom/tech-news.svg)](https://gemnasium.com/tmknom/tech-news)


## セットアップ

```bash
git clone https://github.com/tmknom/tech-news.git
cd tech-news
bundle install --path vendor/bundle --without development
RAILS_ENV=production bundle exec rake db:migrate
```

## デプロイ

CodeDeploy経由でデプロイする

### Production 環境へデプロイ

```bash
fab deploy_production
```

### Administration 環境へデプロイ

```bash
fab deploy_administration
```

### CodeDeploy のゴミの削除

CodeDeploy が以上終了した場合に使う。

```bash
fab cleanup_code_deploy -H <ip_address>
```

## EC2インスタンスセットアップ

```bash
fab init_env -H <ip_address>
```

## データベースセットアップ

```bash
fab init_db -H <ip_address>
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
RAILS_ENV=production bundle exec sidekiq -q default -q rss -q rating -L /var/log/app/sidekiq.log -P tmp/pids/sidekiq.pid -d
```

### 終了

```bash
RAILS_ENV=production bundle exec sidekiqctl stop tmp/pids/sidekiq.pid
```


## cronの設定

### 設定確認

```bash
RAILS_ENV=production bundle exec whenever
```

### 設定反映

```bash
RAILS_ENV=production bundle exec whenever --update-crontab
```

### 設定削除

```bash
RAILS_ENV=production bundle exec whenever --clear-crontab
```

## .envrc

ローカルの環境変数の設定はdirenvを使用する。
envrc.example を参考に設定する。

### 設定方法

```bash
direnv edit .
```

### 設定内容

```bash
cat envrc.example
```
