pipeline {
  agent any

  environment {
    AWS_REGION = 'your-region'
    ECR_REPOSITORY = 's3-to-rds-glue'
    ACCOUNT_ID = 'your-account-id'
  }

  stages {
    stage('Checkout') {
      steps {
        git 'https://github.com/yourusername/your-repo.git'
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          dockerImage = docker.build("${ECR_REPOSITORY}:latest")
        }
      }
    }

    stage('Login to AWS ECR') {
      steps {
        sh '''
        aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
        '''
      }
    }

    stage('Push Image to ECR') {
      steps {
        script {
          dockerImage.push()
        }
      }
    }

    stage('Terraform Deploy') {
      steps {
        sh '''
        terraform init
        terraform apply -auto-approve
        '''
      }
    }

    stage('Test Lambda') {
      steps {
        echo 'Invoke Lambda or verify deployment here.'
      }
    }
  }
}
