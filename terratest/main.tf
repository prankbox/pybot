terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

#Region
provider "aws" {
  region = "us-east-1"
}

data "aws_ecr_repository" "service" {
  name = "bot"
}

data "aws_ecr_image" "service_image" {
  repository_name = "bot"
  image_tag       = "jenkins-Bot-Pipeline-77"
}

module "bot_lambda" {
  source         = "terraform-aws-modules/lambda/aws"
  function_name  = "telegram-cripto-bot"
  create_package = false
  image_uri      = "${data.aws_ecr_repository.service.repository_url}:${data.aws_ecr_image.service_image.image_tag}"
  package_type   = "Image"

  environment_variables = {
    TELEGRAM_TOKEN = "TEKEN"
  }


  tags = {
    Name = "tg-bot-lambda"
  }

}


output "image" {
  value = data.aws_ecr_image.service_image.image_tags
}

output "repo_arn" {
  value = data.aws_ecr_repository.service.arn
}

output "repo_name" {
  value = data.aws_ecr_repository.service.repository_url
}

output "repo_tags" {
  value = data.aws_ecr_repository.service.tags
}