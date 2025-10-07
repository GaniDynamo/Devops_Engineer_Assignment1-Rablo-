DevOps Engineer Assignment 1: S3 to RDS/Glue Data Pipeline CI/CD
This repository contains the solution for the DevOps Engineer Assignment, demonstrating a complete CI/CD pipeline for deploying a containerized data processing application to AWS.

The pipeline uses Jenkins to orchestrate Terraform for infrastructure provisioning and Docker/ECR for application deployment.

🚀 Architecture and Process Flow
The core architecture utilizes a decoupled approach to handle the circular dependency between ECR creation and Lambda deployment.

Stage

Tool

Description

1. Infra Prerequisites

Terraform (Targeted Apply)

Creates the non-dependent AWS resources: ECR Repository, S3 Bucket, IAM Role, and RDS Subnet Group.

2. Build & Push Image

Docker / AWS CLI

Authenticates with ECR, builds the Python application image, tags it, and pushes it to the ECR repository.

3. Final Deployment

Terraform (Full Apply)

Runs the final deployment, creating the AWS Lambda function and referencing the image that is now available in ECR.

🛠️ Repository Contents
File

Purpose

Details

Jenkinsfile

CI/CD Pipeline

Groovy script defining the 4-stage automated deployment process. Crucial for dependency resolution.

main.tf

Infrastructure as Code

HCL definition for all AWS resources, including aws_ecr_repository.repo, aws_s3_bucket.data_bucket, aws_db_instance.rds, aws_iam_role.lambda_exec_role, and aws_lambda_function.my_lambda.

s3_to_rds_glue.py

Application Logic

Python script to read from S3, attempt to insert data into PostgreSQL RDS, and fallback to writing to Glue Data Catalog upon failure.

Dockerfile

Containerization

Defines the image environment (python:3.9-slim), installs boto3 and psycopg2-binary dependencies, and packages the application script.

☁️ AWS Resources Deployed
The Terraform configuration creates the following resources in the us-east-1 region:

ECR Repository: s3-to-rds-glue-pipe

S3 Bucket: rablo-bucket-pipe-2804

RDS Subnet Group: rablo-rds-pipe1-subnet-group

IAM Role: lambda-exec-role-pipe1 (Lambda Execution Role)

AWS Lambda: s3_to_rds_glue_lambda-pipe1 (Container-based function)

RDS Instance: PostgreSQL database instance.

⚙️ Setup and Execution
Prerequisites
A running Jenkins instance.

AWS CLI installed on the Jenkins agent.

Terraform CLI installed on the Jenkins agent.

Docker installed on the Jenkins agent.

An AWS IAM Role configured with necessary permissions (ECR, Lambda, S3, RDS, Glue).

An AWS Credentials entry in Jenkins named aws-credential-id.

Running the Pipeline
In Jenkins, create a New Item of type Pipeline.

Configure the pipeline to use "Pipeline script from SCM" (Git).

Set the Repository URL to: https://github.com/GaniDynamo/Devops_Engineer_Assignment1-Rablo-.git

Set the Branch Specifier to main.

Save and click Build Now.

The Jenkins pipeline will automatically clone the repository and execute the four deployment stages defined in the Jenkinsfile.
