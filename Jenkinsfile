pipeline {
    agent { label 'mykubeapp' }
    options {
        disableConcurrentBuilds()
        timeout(time: 30, unit: 'MINUTES')
    }
    parameters {
        booleanParam(name: 'DEPLOY_LOCAL', defaultValue: false,
                     description: 'Deploy to the dedicated kind cluster on this agent')
    }
    environment {
        CLUSTER_NAME = 'mykubeapp-build'
    }
    stages {
        stage('Test') {
            steps {
                sh '''
                    python3 -m venv .venv
                    .venv/bin/python -m pip install -r requirements-dev.txt
                    .venv/bin/python -m pytest
                    bash scripts/test-java.sh
                '''
            }
        }
        stage('Build') {
            steps {
                sh 'IMAGE_TAG="$GIT_COMMIT" bash scripts/build.sh'
            }
        }
        stage('Deploy and verify') {
            when { expression { params.DEPLOY_LOCAL } }
            steps {
                sh '''
                    IMAGE_TAG="$GIT_COMMIT" bash scripts/deploy.sh
                    bash scripts/smoke-test.sh
                '''
            }
        }
    }
}
