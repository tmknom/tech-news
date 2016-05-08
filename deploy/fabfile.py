# -*- encoding:utf-8 -*-
from fabric.api import *
from datetime import datetime

HOME_DIR = '/var/www'
RELEASES_DIR = HOME_DIR + '/releases'
CURRENT_DIR = HOME_DIR + '/current'
PID_DIR = '/var/run/app'
APPLICATION_USER = 'rails'

BUNDLE_COMMAND = 'source %s/.bash_profile && RAILS_ENV=production /opt/.rbenv/shims/bundle' % (HOME_DIR)


@task
def application_stop():
    stop_unicorn()
    stop_sidekiq()


def stop_unicorn():
    try:
        with lcd(CURRENT_DIR):
            local('cat %s/unicorn.pid | xargs kill -9' % (PID_DIR))
    except:
        print('unicorn is already stopped...')


def stop_sidekiq():
    try:
        with lcd(CURRENT_DIR):
            local("%s exec sidekiqctl stop %s/sidekiq.pid" % (BUNDLE_COMMAND, PID_DIR))
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
    db_migrate()
    set_cron()


def bundle_install():
    with lcd(CURRENT_DIR):
        local('%s install --path %s/vendor/bundle --without development --frozen' % (BUNDLE_COMMAND, HOME_DIR))


def db_migrate():
    with lcd(CURRENT_DIR):
        local('%s exec rake db:migrate' % (BUNDLE_COMMAND))


def set_cron():
    with lcd(CURRENT_DIR):
        local('%s exec whenever --update-crontab' % (BUNDLE_COMMAND))


@task
def application_start():
    with lcd(CURRENT_DIR):
        local('%s exec unicorn -c ./config/unicorn.rb -D' % (BUNDLE_COMMAND))
        local('%s exec sidekiq -C ./config/sidekiq.yml -d' % (BUNDLE_COMMAND))


@task
def validate_service():
    # AWS CodeDeployで/scripts 以下を更新しても古いスクリプトが動く時の対策
    # http://note.next-season.net/aws/778
    pass
