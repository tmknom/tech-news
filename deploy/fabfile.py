# -*- encoding:utf-8 -*-
from fabric.api import *
from datetime import datetime

HOME_DIR = '/home/ec2-user'
RELEASES_DIR = HOME_DIR + '/releases'
CURRENT_DIR = HOME_DIR + '/current'

@task
def application_stop():
  local('RAILS_ENV=production bundle exec sidekiqctl stop tmp/pids/sidekiq.pid')
  local('cat tmp/pids/server.pid | xargs kill -9')

@task
def before_install():
  create_log_dir()
  create_release_dir()

def create_log_dir():
  local('sudo mkdir -p /var/log/app')
  local('sudo chmod 777 /var/log/app')

def create_release_dir():
  deployment_id = local('printenv DEPLOYMENT_ID', capture=True)
  current_date = datetime.now().strftime("%Y%m%d_%H%M%S")
  release_dir = RELEASES_DIR + '/' + current_date +'_' + deployment_id
  local('mkdir -p %s' % (release_dir))
  local('ln -snf %s %s' % (release_dir, CURRENT_DIR))


@task
def after_install():
  bundle_install()
  db_migrate()
  set_secret_key_base()
  set_cron()

def bundle_install():
  local('bundle install --path vendor/bundle --without development')

def db_migrate():
  local('RAILS_ENV=production bundle exec rake db:migrate')

def set_secret_key_base():
  secret_key_base = local('printenv SECRET_KEY_BASE', capture=True)
  if not secret_key_base:
    secret_key_base = local('RAILS_ENV=production bundle exec rake secret')
    local('echo "export SECRET_KEY_BASE=%s" >> ~/.bash_profile' % (secret_key_base))
    local('source ~/.bash_profile')

def set_cron():
  local('RAILS_ENV=production bundle exec whenever --update-crontab')


@task
def application_start():
  local('RAILS_ENV=production bundle exec rails s -b 0.0.0.0 -d')
  local('RAILS_ENV=production bundle exec sidekiq -q default -q rss -q rating -L /var/log/app/sidekiq.log -P tmp/pids/sidekiq.pid -d')

@task
def validate_service():
  # AWS CodeDeployで/scripts 以下を更新しても古いスクリプトが動く時の対策
  # http://note.next-season.net/aws/778
  pass

