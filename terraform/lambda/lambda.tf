data "aws_ecr_repository" "service" {
  name = "bot"
}

data "aws_ecr_image" "service_image" {
  repository_name = "bot"
  image_tag       = var.image_tag
}

module "bot_lambda" {
  source         = "terraform-aws-modules/lambda/aws"
  function_name  = var.lambda_function_name
  create_package = false
  image_uri      = "${data.aws_ecr_repository.service.repository_url}:${data.aws_ecr_image.service_image.image_tag}"
  package_type   = "Image"

  environment_variables = {
    TELEGRAM_TOKEN = var.token
  }


  tags = {
    Name = "tg-bot-lambda"
  }

}