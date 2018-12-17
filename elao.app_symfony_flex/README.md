# Elao - App Symfony Flex

## Jenkins

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
