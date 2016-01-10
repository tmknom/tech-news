# -*- encoding:utf-8 -*-
from fabric.api import *
from datetime import datetime

REPOSITORY = 'tmknom/tech-news'
WORK_DIR = datetime.now().strftime("%Y%m%d_%H%M%S")

@task
def deploy():
  execute_deploy()

def execute_deploy():
  clone()
  bundle_install()
  db_migrate()

def clone():
  repository_url = 'https://github.com/' + REPOSITORY + '.git'
  run('git clone %s %s' %(repository_url, WORK_DIR))

def bundle_install():
  with cd(WORK_DIR):
    run('bundle install --path vendor/bundle --without development')

def db_migrate():
  with cd(WORK_DIR):
    run('RAILS_ENV=production bundle exec rake db:migrate')
