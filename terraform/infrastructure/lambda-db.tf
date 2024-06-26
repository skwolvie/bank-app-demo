# Create a custom IAM policy for Lambda functions to access VPC resources
resource "aws_iam_policy" "lambda_vpc_access" {
  name        = "lambda_vpc_access"
  description = "Allows Lambda functions to manage ENIs for VPC access"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface",
          "ec2:AssignPrivateIpAddresses",
          "ec2:UnassignPrivateIpAddresses"
        ],
        Resource = "*",
        Effect   = "Allow"
      }
    ]
  })
}

# Define the IAM role that the Lambda function will assume
resource "aws_iam_role" "lambda_role" {
  name = "database_lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

# Attach the AWS-managed policy for basic Lambda execution to the role
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Attach the custom VPC access policy created earlier to the same role
resource "aws_iam_role_policy_attachment" "lambda_vpc_access_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_vpc_access.arn
}

# Security Group module for the database
module "lambda-security-group" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-security-group.git?ref=43974e94067251ee464018288aa44862d0adba22"

  # Basic configuration of the security group
  name        = "lambda-sg"
  description = "Lambda function security group"
  vpc_id      = module.vpc.vpc_id

  # Ingress rules for the security group, allowing database access
  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "Database access from within VPC"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
  ]
  # Egress rules - allowing all outbound traffic from the Lambda
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1" # "-1" signifies all protocols
      description = "Allow all outbound traffic from Lambda"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}

# Create the Lambda function which creates user and database
resource "aws_lambda_function" "create_database" {
  filename      = "${path.cwd}/../../create-database-lambda-function/db-function.zip"
  function_name = "create-database"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler" # Adjust based on your language/runtime and entry point
  runtime       = "python3.10"                     # Specify the appropriate runtime

  source_code_hash = filebase64sha256("${path.cwd}/../../create-database-lambda-function/db-function.zip")

  vpc_config {
    subnet_ids         = module.vpc.database_subnets
    security_group_ids = [module.lambda-security-group.security_group_id]
  }
}

