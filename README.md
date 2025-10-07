<h1>📦 DevOps Engineer Assignment 1: S3 to RDS/Glue Data Pipeline CI/CD</h1>

This repository contains the complete solution for the DevOps Engineer Assignment, demonstrating a fully automated CI/CD pipeline for deploying a containerized data processing application to AWS using Jenkins and Terraform.

<h2>🚀 Architecture and Process Flow</h2>

The CI/CD solution, orchestrated by Jenkins, uses a decoupled Terraform deployment strategy to resolve the critical circular dependency between the ECR repository creation and the Lambda function deployment.

The pipeline is structured into four main stages:

Stage 1: Infra Prerequisites (Targeted Terraform Apply): Creates foundational AWS resources (ECR Repository, S3 Bucket, IAM Role, and RDS Subnet Group), intentionally skipping the dependent Lambda function.

Stage 2: Authenticate with AWS and ECR: Performs Docker login authentication against the newly created ECR registry.

Stage 3: Build & Push Docker Image: Builds the application's container image, tags it, and pushes it to ECR.

Stage 4: Final Deployment (Full Terraform Apply): Executes the full Terraform configuration, which successfully creates the AWS Lambda function because its required ECR image is now available.

<h2>🛠️ Repository Contents</h2>

The project relies on four core files:

File Name

Role

Key Functionality

Jenkinsfile

CI/CD Orchestration

Defines the multi-stage, dependency-aware pipeline execution logic (Groovy Script).

main.tf

Infrastructure as Code

Defines all AWS resources in HCL (ECR, RDS, Lambda, S3, IAM).

s3_to_rds_glue.py

Application Logic

Python script to read from S3, attempt data insert to PostgreSQL RDS, and implement a fallback mechanism to Glue Data Catalog.

Dockerfile

Containerization

Packages the Python application, installing necessary libraries (boto3, psycopg2-binary) onto a python:3.9-slim base image.

<h2>☁️ AWS Resources Deployed (us-east-1)</h2>

The Terraform configuration provisions the following key resources:

ECR Repository: s3-to-rds-glue-pipe (Container Image Host)

S3 Bucket: rablo-bucket-pipe-2804 (Source Data Storage)

RDS Subnet Group: rablo-rds-pipe1-subnet-group (Required for RDS instance)

RDS Instance: PostgreSQL database instance

IAM Role: lambda-exec-role-pipe1 (Lambda Execution Role)

AWS Lambda: s3_to_rds_glue_lambda-pipe1 (Container-based application function)

<h2>⚙️ Setup and Execution</h2>

<h3>Prerequisites on Jenkins Agent</h3>

The Jenkins build agent must have the following tools installed and configured:

A running Jenkins instance.

AWS CLI and Terraform CLI.

Docker installed and running.

A pre-configured AWS IAM Role with permissions for ECR, Lambda, S3, RDS, and Glue actions.

An AWS Credentials entry in Jenkins named aws-credential-id for pipeline access.

<h3>Running the Pipeline</h3>

In the Jenkins dashboard, create a New Item and select the Pipeline project type.

In the pipeline configuration, choose "Pipeline script from SCM" (Git).

Set the Repository URL to: https://github.com/GaniDynamo/Devops_Engineer_Assignment1-Rablo-.git

Ensure the Branch Specifier is set to main.

Save the configuration and click Build Now.

The Jenkins pipeline will automatically clone the repository and execute the four defined deployment stages, managing infrastructure and application deployment end-to-end.
