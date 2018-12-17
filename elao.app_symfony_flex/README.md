# Elao - App Symfony Flex

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
