# Elao - App Symfony Flex

* [Overview](#overview)
* [Quick start](#quick-start)
* [System](#system)
* [Releases](#releases)
* [Makefile](#makefile)
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

Then update the `.manala.yaml` file (see [the releases example](#releases) below) and then run the `manala up` command:

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
  docker Run docker container

App:
```

## System

Here is an example of a system configuration in `.manala.yaml`:

```yaml
system:
  php:
    version: 7.3
  nodejs:
    version: 12
  ssh:
    config: |
      Host *.elao.run
        User         app
        ForwardAgent yes
      Host *.elao.local
        User         app
        ForwardAgent yes
        ProxyJump    gateway@bastion.elao.com
```

## Releases

Here is an example of a production/staging release configuration in `.manala.yaml`:

```yaml
releases:

  - &release
    #app: api # Optionnal
    #app_dir: api # Optionnal, <app> by default
    env: production
    #env_branch: api/production # Optionnal, <app>/<env> by default
    repo: git@git.elao.com:<vendor>/<app>-release.git
    # Release
    release_tasks:
      - shell: make install@production
      - shell: make build@production
    # You can either explicitly list all the paths you want to include
    release_add:
      - bin
      - config
      - public
      - src
      - templates
      - translations
      - vendor
      - composer.* # Composer.json required by src/Kernel.php to determine project root dir
                   # Composer.lock required by composer on post-install (warmup)
      - Makefile

    # Or you can include all by default and only list the paths you want to exclude
    # release_removed:
    #   - ansible
    #   - build
    #   - doc
    #   - node_modules
    #   - tests
    #   - .env.test
    #   - .php_cs.dist
    #   - .manala*
    #   - package.json
    #   - phpunit.xml.dist
    #   - README.md
    #   - Vagrantfile
    #   - webpack.config.js
    #   - yarn.lock

    # Deploy
    deploy_hosts:
      - ssh_host: foo-01.bar.elao.local
        #master: true # Any custom variable are welcomed
      - ssh_host: foo-02.bar.elao.local
    deploy_dir: /srv/app
    deploy_shared_files:
      - config/parameters.yml
    deploy_shared_dirs:
      - var/log
    deploy_tasks:
      - shell: make warmup@production
      #- shell: make migration@production
      #  when: master | default # Conditions on custom host variables (jinja2 format)
    deploy_post_tasks:
      - shell: sudo systemctl reload php7.3-fpm

  - << : *release
    env: staging
    tasks:
      - shell: make install@staging
      - shell: make build@staging
    # Deploy
    deploy_hosts:
      - ssh_host: foo.bar.elao.ninja.local
    deploy_tasks:
      - shell: make warmup@staging
```

## Makefile

Makefile targets that are supposed to be runned via docker must be prefixed.

```
foo: SHELL := $(or $(DOCKER_SHELL),$(SHELL))
foo:
	# Do something really foo...
```

Ssh
```
#######
# Ssh #
#######

## Ssh to staging server
ssh@staging: SHELL := $(or $(DOCKER_SHELL),$(SHELL))
ssh@staging:
	ssh app@foo.staging.elao.run

# Single host...

ssh@production: SHELL := $(or $(DOCKER_SHELL),$(SHELL))
ssh@production:
	...

# Multi host...

ssh@production-01: SHELL := $(or $(DOCKER_SHELL),$(SHELL))
ssh@production-01:
	...
```

Sync
```
sync@staging: SHELL := $(or $(DOCKER_SHELL),$(SHELL))
sync@staging:
	mkdir --parents var
	rsync --archive --compress --verbose --delete-after \
		app@foo.staging.elao.run:/srv/app/current/var/files/ \
		var/files/

# Multi targets...
sync-uploads@staging: SHELL := $(or $(DOCKER_SHELL),$(SHELL))
sync-uploads@staging:
  ...

# Multi apps...
sync.api-uploads@staging: SHELL := $(or $(DOCKER_SHELL),$(SHELL))
sync.api-uploads@staging:
  ...
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
            filename '.manala/docker/Dockerfile'
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
