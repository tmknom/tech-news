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
  initialize_dir()
  clone()
  bundle_install()
  db_migrate()
  symlink()

def initialize_dir():
  env.release_dir = RELEASES_DIR + '/' + WORK_DIR
  run('mkdir -p %s' % (RELEASES_DIR))

def clone():
  repository_url = 'https://github.com/' + REPOSITORY + '.git'
  with cd(RELEASES_DIR):
    run('git clone %s %s' %(repository_url, WORK_DIR))

def bundle_install():
  with cd(env.release_dir):
    run('bundle install --path vendor/bundle --without development')

def db_migrate():
  with cd(env.release_dir):
    run('RAILS_ENV=production bundle exec rake db:migrate')

def symlink():
  run('ln -snf %s %s' % (env.release_dir, CURRENT_DIR))

