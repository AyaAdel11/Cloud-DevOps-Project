@Library('my-shared-library') _

pipeline {
 
    agent any

    environment {
        APP_NAME = 'jenkins-app'
        DOCKER_USER = "ayaadel02"
        IMAGE_NAME = "${DOCKER_USER}/${APP_NAME}"
        IMAGE_TAG = "1.0.0-${BUILD_NUMBER}"
    }

    stages {
        stage("Cleanup Workspace") {
            steps {
                cleanWs()
            }
        }

        stage("Checkout from SCM") {
            steps {
                git branch: 'main', credentialsId: 'github-creds', url: 'https://github.com/AyaAdel11/Cloud-DevOps-Project.git'
            }
        }

        stage("Test Application") {
            steps {
                runUnitTest() 
            }
        }

        stage("Build Application") {
            steps {
                buildApp()
            }
        }

        stage("Build Docker Image") {
            steps {
                buildImage("${IMAGE_NAME}:${IMAGE_TAG}")
                sh "docker rmi ${IMAGE_NAME}:latest || true"
                sh "docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest"
                
            }
        }

        stage("Security Scan") {
            steps {
                scanImage("${IMAGE_NAME}:${IMAGE_TAG}")
            }
        }

        stage("Push Docker Image") {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                    sh "echo \$PASS | docker login -u \$USER --password-stdin"
                    pushImage("${IMAGE_NAME}:${IMAGE_TAG}")
                    pushImage("${IMAGE_NAME}:latest")
                }
            }
        }

        stage("Update Manifest & Push to GitHub") {
    steps {
        sh "sed -i 's|image: ${IMAGE_NAME}:.*|image: ${IMAGE_NAME}:${IMAGE_TAG}|g' deployment.yaml"
        
        withCredentials([usernamePassword(credentialsId: 'github-creds', passwordVariable: 'GIT_PASS', usernameVariable: 'GIT_USER')]) {
            sh """
                git config user.email "jenkins-bot@example.com"
                git config user.name "Jenkins Bot"
                git add deployment.yaml
                git commit -m "Update image to ${IMAGE_TAG} [skip ci]"
                
                # إعداد الـ URL ليشمل الـ Credentials للرفع
                git push https://${GIT_USER}:${GIT_PASS}@github.com/AyaAdel11/Jenkins-app.git main
            """
        }
    }
}

        
        stage("Cleanup Local Images") {
            steps {
                removeImageLocally("${IMAGE_NAME}:${IMAGE_TAG}")
                removeImageLocally("${IMAGE_NAME}:latest")
            }
        }
    }

    post {
        always {
            echo 'Pipeline execution finished.'
        }
        success {
            echo 'Deployment successful! Application is live.'
        }
        failure {
            echo 'Pipeline failed. Check Console Output.'
        }
    }
}
