# -*- encoding:utf-8 -*-
from fabric.api import *
from datetime import datetime

HOME_DIR = '/home/ec2-user'
RELEASES_DIR = HOME_DIR + '/releases'
CURRENT_DIR = HOME_DIR + '/current'
PID_DIR = HOME_DIR + '/tmp/pids'
APPLICATION_USER = 'ec2-user'

@task
def application_stop():
  with lcd(CURRENT_DIR):
    local('RAILS_ENV=production bundle exec sidekiqctl stop %s/sidekiq.pid' % (PID_DIR))
    local('cat %s/server.pid | xargs kill -9' % (PID_DIR))

@task
def before_install():
  create_log_dir()
  create_release_dir()
  create_pid_dir()
  create_bundle_config_dir()

def create_log_dir():
  local('mkdir -p /var/log/app')
  local('chmod 777 /var/log/app')
  local('chown %s:%s /var/log/app' % (APPLICATION_USER, APPLICATION_USER))

def create_release_dir():
  deployment_id = local('printenv DEPLOYMENT_ID', capture=True)
  current_date = datetime.now().strftime("%Y%m%d_%H%M%S")
  release_dir = RELEASES_DIR + '/' + current_date +'_' + deployment_id
  local('mkdir -p %s' % (release_dir))
  local('chown %s:%s %s' % (APPLICATION_USER, APPLICATION_USER, release_dir))
  local('ln -snf %s %s' % (release_dir, CURRENT_DIR))

def create_pid_dir():
  local('mkdir -p %s' % (PID_DIR))
  local('chown %s:%s %s' % (APPLICATION_USER, APPLICATION_USER, PID_DIR))

def create_bundle_config_dir():
  # .bundle/config が /opt/codedeploy-agentディレクトリ配下に作られる対策
  local('mkdir -p %s' % ('/opt/codedeploy-agent/.bundle'))
  local('chown %s:%s /opt/codedeploy-agent/.bundle' % (APPLICATION_USER, APPLICATION_USER))


@task
def after_install():
  bundle_install()
  db_migrate()
  set_secret_key_base()
  set_cron()

def bundle_install():
  with lcd(CURRENT_DIR):
    local('bundle install --path %s/vendor/bundle --without development --frozen' % (HOME_DIR))

def db_migrate():
  with lcd(CURRENT_DIR):
    local('source %s/.bash_profile && RAILS_ENV=production bundle exec rake db:migrate' % (HOME_DIR))

def set_secret_key_base():
  try:
    secret_key_base = local('source %s/.bash_profile && printenv SECRET_KEY_BASE' % (HOME_DIR), capture=True)
  except:
    secret_key_base = None

  if not secret_key_base:
    with lcd(CURRENT_DIR):
      secret_key_base = local('RAILS_ENV=production bundle exec rake secret', capture=True)
      local('echo "export SECRET_KEY_BASE=%s" >> %s/.bash_profile' % (secret_key_base, HOME_DIR))
      local('source %s/.bash_profile' % (HOME_DIR))

def set_cron():
  with lcd(CURRENT_DIR):
    local('RAILS_ENV=production bundle exec whenever --update-crontab')


@task
def application_start():
  with lcd(CURRENT_DIR):
    local('source %s/.bash_profile && RAILS_ENV=production bundle exec rails s -b 0.0.0.0 -P %s/server.pid -d' % (HOME_DIR, PID_DIR))
    local('RAILS_ENV=production bundle exec sidekiq -q default -q rss -q rating -L /var/log/app/sidekiq.log -P %s/sidekiq.pid -d' % (PID_DIR))

@task
def validate_service():
  # AWS CodeDeployで/scripts 以下を更新しても古いスクリプトが動く時の対策
  # http://note.next-season.net/aws/778
  pass

