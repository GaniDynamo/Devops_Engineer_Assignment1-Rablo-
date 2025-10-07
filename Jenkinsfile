pipeline {
  agent any

  environment {
    AWS_DEFAULT_REGION = 'us-east-1'
    ECR_REPOSITORY = 's3-to-rds-glue-pipe'
    AWS_ACCOUNT_ID = '442426871791'
  }
  stages {
      stage('clean workspace') {
          steps {
              cleanWs()
          }
      }
      stage('Git Checkout') {
          steps {
              git branch: 'main', url: 'https://github.com/GaniDynamo/Devops_Engineer_Assignment1-Rablo-.git'
          }
      }
      
      // FIX 1: Initial Terraform Apply (Create ECR, IAM, S3, NOT Lambda)
      stage('Terraform Init & Infra Creation') {
    steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credential-id']]) {
            script {
                sh '''
                    terraform init
                    
                    # Run a partial apply, skipping the aws_lambda_function to avoid the dependency error
                    # This requires that your main.tf uses the resource name 'my_lambda'
                    echo "Running partial Terraform Apply, skipping Lambda function creation..."
                    terraform apply -auto-approve -target=aws_ecr_repository.repo -target=aws_iam_role.lambda_exec_role -target=aws_s3_bucket.data_bucket -target=aws_db_subnet_group.rds_subnet_group
                '''
            }
        }
    }
}

      stage('Authenticate with AWS and ECR') {
    steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credential-id']]) {
            sh '''
                echo "Authenticating with AWS for ECR Login..."
                export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY

                aws sts get-caller-identity
                
                echo "Logging into ECR..."
                aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | \
                docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com
            '''
        } 
    }
}

      stage('Build, Tag & Push Docker Image') {
    steps {
        script {
            def IMAGE_TAG = "1.0.${currentBuild.number}"
            def ECR_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${ECR_REPOSITORY}"

            sh """
                echo "Building Docker image..."
                docker build -t s3-to-rds-glue:latest .

                echo "Tagging image with ${IMAGE_TAG} and latest..."
                docker tag s3-to-rds-glue:latest ${ECR_URI}:${IMAGE_TAG}
                docker tag s3-to-rds-glue:latest ${ECR_URI}:latest
                
                echo "Pushing images to ECR..."
                docker push ${ECR_URI}:${IMAGE_TAG}
                docker push ${ECR_URI}:latest
                sleep 10
            """
        }
    }
}
      
      // FIX 2: Final Terraform Apply (Create Lambda and finish any missing resources)
      stage('Final Terraform Apply & Lambda Deployment') {
    steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credential-id']]) {
            script {
                sh '''
                    echo "Running final Terraform Apply to deploy Lambda function..."
                    terraform apply -auto-approve
                '''
            }
        }
    }
}


          }
      }
