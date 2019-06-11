# Elao - App Symfony Flex

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
