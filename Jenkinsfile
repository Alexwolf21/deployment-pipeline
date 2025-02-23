pipeline {
    agent any

    environment {
        IMAGE_NAME = "sample-app"
    }

    stages {
        stage('Checkout'){
            steps{
                checkout scm
            }
        }
        stage('Build'){
            steps{
                script {
                    dockerImage = docker.build("${IMAGE_NAME}:${env.BUILD_NUMBER}")
                }
            }
        }
        stage('Test'){
            steps{
                echo 'Running scripts...'
                bat 'npm test'
            }
        }
        stage('Deploy'){
            steps{
                script {
                    bat 'docker rm -f sample-app || echo Container not found'
                    bat "docker run -d --name sample-app -p 8081:3000 ${IMAGE_NAME}:${env.BUILD_NUMBER}"
                }
            }
        }
    }
    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed'
        }
    }
}
