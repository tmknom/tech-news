# -*- encoding:utf-8 -*-

from fabric.api import *
from fabric.contrib.console import *

APPLICATION_NAME = 'tech-news'
REPOSITORY = 'tmknom/tech-news'

TESTING = 'Testing'
PRODUCTION = 'Production'


def deploy_production(branch='master'):
    if not confirm("%s ブランチを Production 環境へデプロイします。本当に実行しますか？" % (branch)):
        abort('実行を中止しました。')
    deploy(branch, PRODUCTION)


def deploy_testing(branch):
    deploy(get_branch(branch), TESTING)


def deploy(branch, environment):
    recent_commit_id = get_recent_commit_id(branch)
    create_deployment(recent_commit_id, environment)


def create_deployment(commit_id, environment):
    region = get_default_region()
    deployment_group_name = environment + '-' + APPLICATION_NAME
    execute_create_deployment(commit_id, deployment_group_name, region, APPLICATION_NAME, REPOSITORY)


def execute_create_deployment(commit_id, deployment_group_name, region, application_name, repository):
    command = "aws deploy create-deployment " \
              + " --ignore-application-stop-failures " \
              + " --region %s " % (region) \
              + " --application-name %s " % (application_name.lower()) \
              + " --deployment-group-name %s " % (deployment_group_name.lower()) \
              + " --github-location commitId=%s,repository=%s " % (commit_id, repository)
    result = local(command, capture=True)
    return result


def get_default_region():
    command = 'aws configure get region'
    result = local(command, capture=True)
    return result


def get_recent_commit_id(branch):
    command = 'git log -n 1 --format=%H ' + branch
    result = local(command, capture=True)
    return result


def get_branch(branch):
    if not branch:
        return branch
    return get_current_branch()


def get_current_branch():
    command = "git rev-parse --abbrev-ref HEAD"
    result = local(command, capture=True)
    return result


@task
def cleanup_code_deploy():
    sudo('rm -Rf /opt/codedeploy-agent/deployment-root/*')
