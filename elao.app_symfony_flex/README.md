# Elao - App Symfony Flex

* [Overview](#overview)
* [Quick start](#quick-start)
* [Release](#release)
* [Deploy](#deploy)
* [Git tools](#git-tools)
* [Jenkins](#jenkins)

## Overview

This template contains some helpful scripts in the context of a Symfony app, such as Makefile tasks in order to release and deploy your app.

## Quick start

In a shell terminal, change directory to your Symfony app, and run the following commands:

```shell
    $ cd /path/to/my/symfony-app
    $ manala init
    # Select the "elao.app_symfony_flex" template
    $ manala up
```

Edit the `Makefile` at the root directory of your project and add the following lines at the beginning of the file:

```
.SILENT:

-include .manala/make/Makefile
```

Then update the `.manala.yaml` file (see [the release example](#release) below) and then run the `manala up` command:

```
    $ manala up
```

> :warning: don't forget to run the `manala up` command each time you update the `.manala.yaml` file to actually apply your changes !!!

From now on, if you execute the `make help` command in your console, you should obtain the following output:

```shell
Usage: make [target]

Help:
  help This help

Docker:
  docker.sh  Run shell
Release:
  release@production Release in production
Deploy:
Project:
```

## Release

Here is an example of a production release configuration in `.manala.yaml`:

```yaml
release:
  production:
    original_commit_prefix: https://github.com/elao/wotol/commit/
    release_dir: /srv/.manala/build/release
    release_version: production
    release_repo: git@git.elao.com:wotol/wotol-release.git
    # You can either explicitely list all the paths you want to include
    release_add:
      - bin
      - composer.json # Required by src/Kernel.php to determine project root dir
      - composer.lock # Required by composer on post-install (warmup)
      - config
      - public
      - src
      - templates
      - translations
      - var
      - vendor
      - Makefile
    # Or you can include all by default and only list the paths you want to exclude
    # release_add: []
    # release_removed:
    #   - ansible
    #   - build
    #   - doc
    #   - node_modules
    #   - tests
    #   - .dockerignore
    #   - .env.test
    #   - .php_cs.dist
    #   - Jenkinsfile
    #   - .manala
    #   - .manala.local.yaml
    #   - .manala.yaml
    #   - package.json
    #   - phpunit.xml.dist
    #   - README.md
    #   - Vagrantfile
    #   - webpack.config.js
    #   - yarn.lock

    # Or you can both add paths and exclude some other ones
    # release_add:
    #   - bin
    #   - composer.json
    #   - composer.lock
    #   - config
    #   - public
    #   - src
    #   - templates
    #   - translations
    #   - var
    #   - vendor
    #   - Makefile
    # release_remove:
    #   - var/tmp

```

## Deploy

Here is an example of a deploy configuration in `.manala.yaml`:

```yaml
deploy:
  _all:
    vars: &deploy_all_vars
      deploy_dir: /srv/app
      deploy_releases: 4
      deploy_strategy: git
      deploy_strategy_git_repo: git@git.elao.com:<vendor>/<app>-release.git
      deploy_shared_files:
        - config/parameters.yaml
      deploy_shared_dirs:
        - config/jwt
        - public/uploads
        - var/company-assets
        - var/log
        - var/files
  staging:
    hosts:
      staging-1:
        ansible_host: <vendor>.<app>.elao.ninja
    vars:
      << : *deploy_all_vars
      deploy_strategy_git_version: staging
      deploy_tasks:
        - make: warmup@staging
  production:
    hosts:
      production-1:
        ansible_host: <vendor>.<app>.elao.run
    vars:
      << : *deploy_all_vars
      deploy_strategy_git_version: production
      deploy_tasks:
        - make: warmup@production
```

## Git tools

The `elao.app_symfony_flex` template contains some git helpers such as the [`git_diff`](./make/make.git.mk) task.

This task is useful for example to apply `php-cs`, `php-cs-fix` or `PHPStan` checks only on the subset of updated PHP files and not on any PHP file of your project.

Usage (in your `Makefile`):

```shell
## Show code style errors in updated PHP files
cs:
ifeq ($(strip $(call git_diff,php,src tests)),)
    echo "You have made no change in PHP files"
else
    vendor/bin/php-cs-fixer fix --dry-run --diff  --config=.php_cs.dist --path-mode=intersection $(call git_diff,php,src tests)
endif

## Show code style errors in every PHP file
cs-all:
    vendor/bin/php-cs-fixer fix --dry-run --diff
```

## Jenkins

Resources:
* https://jenkins.io/doc/book/pipeline/syntax/#parallel
* https://jenkins.io/blog/2018/07/02/whats-new-declarative-piepline-13x-sequential-stages/

```groovy
pipeline {
    agent {
        dockerfile {
            filename '.manala/docker/Dockerfile.ci'
        }
    }
    environment {
        APP_ENV='test'
    }
    stages {
        stage('Test') {
            steps {
                sh 'make install@ci'
                sh 'make cs@ci || true'
                sh 'make test@ci || true'
                junit 'build/**/*.xml'
            }
        }
    }
}
```
