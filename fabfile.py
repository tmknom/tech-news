# -*- encoding:utf-8 -*-
from fabric.api import *
from datetime import datetime

REPOSITORY = 'tmknom/tech-news'
WORK_DIR = datetime.now().strftime("%Y%m%d_%H%M%S")
RELEASES_DIR = 'releases'
CURRENT_DIR = 'current'

@task
def deploy():
  execute_deploy()

def execute_deploy():
  stop()
  initialize_dir()
  clone()
  symlink()
  bundle_install()
  db_migrate()
  start()

def initialize_dir():
  env.release_dir = RELEASES_DIR + '/' + WORK_DIR
  run('mkdir -p %s' % (RELEASES_DIR))

def clone():
  repository_url = 'https://github.com/' + REPOSITORY + '.git'
  with cd(RELEASES_DIR):
    run('git clone %s %s' %(repository_url, WORK_DIR))

def symlink():
  run('ln -snf %s %s' % (env.release_dir, CURRENT_DIR))

def bundle_install():
  with cd(CURRENT_DIR):
    run('bundle install --path vendor/bundle --without development')

def db_migrate():
  with cd(CURRENT_DIR):
    run('RAILS_ENV=production bundle exec rake db:migrate')

def start():
  with cd(CURRENT_DIR):
    run('RAILS_ENV=production bundle exec rails s -b 0.0.0.0 -d', pty=False)
    run('RAILS_ENV=production bundle exec sidekiq -q default -q rss -q rating -L log/sidekiq.log -P tmp/pids/sidekiq.pid -d', pty=False)

def stop():
  with cd(CURRENT_DIR):
    run('RAILS_ENV=production bundle exec sidekiqctl stop tmp/pids/sidekiq.pid', warn_only=True)
    run('cat tmp/pids/server.pid | xargs kill -9', warn_only=True)
