# -*- encoding:utf-8 -*-
from fabric.api import *
from datetime import datetime

HOME_DIR = '/var/www'
RELEASES_DIR = HOME_DIR + '/releases'
CURRENT_DIR = HOME_DIR + '/current'
PID_DIR = '/var/run/app'
APPLICATION_USER = 'rails'


@task
def application_stop():
    stop_unicorn()
    stop_sidekiq()


def stop_unicorn():
    try:
        local_su('cat %s/unicorn.pid | xargs kill -9' % (PID_DIR), CURRENT_DIR)
    except:
        print('unicorn is already stopped...')


def stop_sidekiq():
    try:
        bundle('exec sidekiqctl stop %s/sidekiq.pid' % (PID_DIR))
    except:
        print('sidekiq is already stopped...')


@task
def before_install():
    create_release_dir()
    create_bundle_config_dir()


def create_release_dir():
    deployment_id = local('printenv DEPLOYMENT_ID', capture=True)
    current_date = datetime.now().strftime("%Y%m%d_%H%M%S")
    release_dir = RELEASES_DIR + '/' + current_date + '_' + deployment_id
    local('mkdir -p %s' % (release_dir))
    local('chown %s:%s %s' % (APPLICATION_USER, APPLICATION_USER, RELEASES_DIR))
    local('chown %s:%s %s' % (APPLICATION_USER, APPLICATION_USER, release_dir))
    local('ln -snf %s %s' % (release_dir, CURRENT_DIR))
    local('chown -h %s:%s %s' % (APPLICATION_USER, APPLICATION_USER, CURRENT_DIR))


def create_bundle_config_dir():
    # .bundle/config が /opt/codedeploy-agentディレクトリ配下に作られる対策
    local('mkdir -p %s' % ('/opt/codedeploy-agent/.bundle'))
    local('chown %s:%s /opt/codedeploy-agent/.bundle' % (APPLICATION_USER, APPLICATION_USER))


@task
def after_install():
    bundle_install()
    assets_precompile()
    db_migrate()
    set_cron()


def bundle_install():
    bundle('install --path %s/vendor/bundle --without development --frozen' % (HOME_DIR))


def assets_precompile():
    bundle('exec rake assets:precompile')


def db_migrate():
    bundle('exec rake db:migrate')


def set_cron():
    bundle('exec whenever --update-crontab')


@task
def application_start():
    bundle('exec unicorn -c ./config/unicorn.rb -D')
    bundle('exec sidekiq -C ./config/sidekiq.yml -d')


@task
def validate_service():
    # AWS CodeDeployで/scripts 以下を更新しても古いスクリプトが動く時の対策
    # http://note.next-season.net/aws/778
    pass


def bundle(bundle_option):
    command = 'source %s/.bashrc && RAILS_ENV=production /opt/.rbenv/shims/bundle %s' % (HOME_DIR, bundle_option)
    local_su(command, CURRENT_DIR)


def local_su(command, lcd):
    local("su -s /bin/bash - -l %s -c 'cd %s && %s' " % (APPLICATION_USER, lcd, command))
