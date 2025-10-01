pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds')  // Docker Hub credentials in Jenkins
        IMAGE_NAME = 'my-php-app'
        DOCKERHUB_USER = 'mame12b'
        EC2_USER = 'ubuntu'  // or ec2-user depending on AMI
        EC2_HOST = '54.197.160.196'
        SSH_KEY = credentials('ec2-ssh-key')  // Jenkins SSH private key
    }

    stages {
        stage('Clone Repository') {
            steps {
                echo "Cloning repository..."
                git url: 'https://github.com/mame12b/projCert.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                // Assuming Dockerfile is in project root
                sh "docker build -t ${IMAGE_NAME} ."
            }
        }

        stage('Push Docker Image to Hub') {
            steps {
                echo "Logging into Docker Hub..."
                sh """
                    echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_USER} --password-stdin
                    docker tag ${IMAGE_NAME} ${DOCKERHUB_USER}/${IMAGE_NAME}:latest
                    docker push ${DOCKERHUB_USER}/${IMAGE_NAME}:latest
                    docker logout
                """
            }
        }

        stage('Deploy to Kubernetes on EC2') {
            steps {
                echo "Deploying to Kubernetes on EC2..."
                sshagent(['ec2-ssh-key']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_HOST} '
                            cd ~/ || mkdir ~/ && cd ~/
                            git clone https://github.com/mame12b/projCert.git || (cd projCert && git pull)
                            cd projCert
                            kubectl apply -f k8s/php-deployment.yaml
                            kubectl apply -f k8s/php-service.yaml
                        '
                    """
                }
            }
        }
    }

    post {
        success {
            echo '✅ Deployment to EC2 Kubernetes cluster completed successfully!'
        }
        failure {
            echo '❌ Deployment failed. Check EC2 logs, connectivity, and Jenkins console.'
        }
    }
}

