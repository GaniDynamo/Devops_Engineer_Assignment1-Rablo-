pipeline {
  agent any

  environment {
    AWS_REGION = 'us-east-1'
    ECR_REPOSITORY = 's3-to-rds-glue'
    ACCOUNT_ID = '442426871791'
    REPO_URI = "${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY}"
    IMAGE_TAG = "latest"
    // DO NOT use static credentials here; use Jenkins credentials binding in the steps below
  }

  stages {
    stage('Checkout') {
      steps {
        git 'https://github.com/GaniDynamo/Devops_Engineer_Assignment1-Rablo-.git'
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          dockerImage = docker.build("${REPO_URI}:${IMAGE_TAG}")
        }
      }
    }

    stage('Login to AWS ECR') {
      steps {
        withCredentials([
          string(credentialsId: 'aws-access-key-id', variable: 'AWS_ACCESS_KEY_ID'),
          string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')
        ]) {
          sh '''
            aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
            aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
            aws configure set region $AWS_REGION
            aws ecr get-login-password --region $AWS_REGION \
              | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
          '''
        }
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
        withCredentials([
          string(credentialsId: 'aws-access-key-id', variable: 'AWS_ACCESS_KEY_ID'),
          string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')
        ]) {
          sh '''
            export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
            export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
            export AWS_DEFAULT_REGION=$AWS_REGION
            terraform init
            terraform apply -auto-approve
          '''
        }
      }
    }

    stage('Test Lambda') {
      steps {
        echo 'Invoke Lambda or verify deployment here.'
        // You can add aws lambda invoke CLI command to test
      }
    }
  }
  post {
    always {
      echo 'Pipeline completed. Check build and deployment status above.'
      // Optionally add notifications (Slack, email, etc.)
    }
  }
}
