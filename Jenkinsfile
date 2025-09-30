pipeline {
  agent any

  environment {
    DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds') // Set this in Jenkins
    IMAGE_NAME = 'my-php-app'
    DOCKERHUB_USER = 'mame12b'
    EC2_USER = 'ubuntu' // or ec2-user depending on AMI
    EC2_HOST = 'your-ec2-public-ip'
    SSH_KEY = credentials('ec2-ssh-key') // Jenkins credential: SSH private key
  }

  stages {
    stage('Clone Repository') {
      steps {
        git 'https://github.com/mame12b/projCert.git'
      }
    }

    stage('Build Docker Image') {
      steps {
        sh "docker build -t ${IMAGE_NAME} ./website"
      }
    }

    stage('Push to Docker Hub') {
      steps {
        sh "echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_USER} --password-stdin"
        sh "docker tag ${IMAGE_NAME} ${DOCKERHUB_USER}/${IMAGE_NAME}"
        sh "docker push ${DOCKERHUB_USER}/${IMAGE_NAME}"
      }
    }

    stage('Deploy to Kubernetes on EC2') {
      steps {
        sshagent(['ec2-ssh-key']) {
          sh """
            ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_HOST} '
              git clone https://github.com/mame12b/projCert.git || true
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
      echo '✅ Deployment to EC2 Kubernetes cluster completed!'
    }
    failure {
      echo '❌ Deployment failed. Check EC2 logs and connectivity.'
    }
  }
}

