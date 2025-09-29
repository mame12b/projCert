pipeline {
  agent any

  environment {
    DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds') // Set this in Jenkins
    IMAGE_NAME = 'my-php-app'
    DOCKERHUB_USER = 'mame12b'
  }

  stages {
    stage('Clone Repository') {
      steps {
        git 'https://github.com/mame12b/projCert.git'
      }
    }

    stage('Build Docker Image') {
      steps {
        sh 'docker build -t $IMAGE_NAME ./website'
      }
    }

    stage('Push to Docker Hub') {
      steps {
	sh "docker build -t ${IMAGE_NAME} ./website"
	sh "echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_USER} --password-stdin"
	sh "docker tag ${IMAGE_NAME} ${DOCKERHUB_USER}/${IMAGE_NAME}"
	sh "docker push ${DOCKERHUB_USER}/${IMAGE_NAME}"

      }
    }

    stage('Deploy to Kubernetes') {
      steps {
        sh 'kubectl apply -f k8s/php-deployment.yaml'
        sh 'kubectl apply -f k8s/php-service.yaml'
      }
    }
  }
}

