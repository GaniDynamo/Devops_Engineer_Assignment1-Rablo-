provider "aws" {
  region = "us-east-1"
}

resource "aws_ecr_repository" "repo" {
  name = "s3-to-rds-glue"
}

resource "aws_s3_bucket" "data_bucket" {
  bucket = "Rablo-bucket2804"
  acl    = "private"
}

resource "aws_db_instance" "rds" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "13.7"
  instance_class       = "db.t3.micro"
  name                 = "Rablodb"
  username             = "Rablodbuser"
  password             = "123456"
  parameter_group_name = "default.postgres13"
  skip_final_snapshot  = true
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda-exec-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_policy" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "my_lambda" {
  function_name = "s3_to_rds_glue_lambda"
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.repo.repository_url}:latest"
  role          = aws_iam_role.lambda_exec_role.arn
  timeout       = 60
}
