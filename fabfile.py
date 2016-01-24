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
  env()
  start()
  cron()

def initialize_dir():
  env.release_dir = RELEASES_DIR + '/' + WORK_DIR
  sudo('mkdir -p /var/log/app')
  sudo('chmod 777 /var/log/app')
  run('mkdir -p %s' % (RELEASES_DIR))

def env():
  secret_key_base = run('printenv SECRET_KEY_BASE', warn_only=True)
  if not secret_key_base:
    with cd(CURRENT_DIR):
      secret_key_base = run('RAILS_ENV=production bundle exec rake secret')
      run('echo "export SECRET_KEY_BASE=%s" >> ~/.bash_profile' % (secret_key_base))
      run('source ~/.bash_profile')

def clone():
  repository_url = 'https://github.com/' + REPOSITORY + '.git'
  with cd(RELEASES_DIR):
    run('git clone %s %s' %(repository_url, WORK_DIR))

def symlink():
  run('ln -snf %s %s' % (env.release_dir, CURRENT_DIR))

def bundle_install():
  with cd(CURRENT_DIR):
    run('git checkout master')
    run('bundle install --path vendor/bundle --without development')

def db_migrate():
  with cd(CURRENT_DIR):
    run('RAILS_ENV=production bundle exec rake db:create')
    run('RAILS_ENV=production bundle exec rake db:migrate')

def start():
  with cd(CURRENT_DIR):
    run('RAILS_ENV=production bundle exec rails s -b 0.0.0.0 -d', pty=False)
    run('RAILS_ENV=production bundle exec sidekiq -q default -q rss -q rating -L /var/log/app/sidekiq.log -P tmp/pids/sidekiq.pid -d', pty=False)

def stop():
  with cd(CURRENT_DIR):
    run('RAILS_ENV=production bundle exec sidekiqctl stop tmp/pids/sidekiq.pid', warn_only=True)
    run('cat tmp/pids/server.pid | xargs kill -9', warn_only=True)

def cron():
  with cd(CURRENT_DIR):
    run('bundle exec whenever --update-crontab')

DEFAULT_SSH_PORT = 37934
@task
def set_sshd():
  pub_key = local('cat provisioning/tech-news.pem.pub', capture=True)
  run('echo %s >> /home/ec2-user/.ssh/authorized_keys' % (pub_key))
  sudo("sed -i 's/^#Port\s\+22/Port %s/' /etc/ssh/sshd_config"  % (DEFAULT_SSH_PORT) )
  sudo("sed -i.bak 's/^#PermitRootLogin\s\+yes/PermitRootLogin no/' /etc/ssh/sshd_config")
  sudo("sed -i 's/^#PubkeyAuthentication\s\+yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config")
  sudo("sed -i 's/^PasswordAuthentication\s\+yes/PasswordAuthentication no/' /etc/ssh/sshd_config")
  sudo("sshd -t")
  sudo("service sshd reload")
  sudo("ps -fea | grep sshd")
