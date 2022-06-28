module "bot_lambda" {
  source = "terraform-aws-modules/lambda/aws"
  function_name = "telegram-cripto-bot"
  create_package = false
  image_uri    = module.docker_image.image_uri
  package_type = "Image"

  environment_variables = {
    TELEGRAM_TOKEN = var.token
  }


  tags = {
    Name = "tg-bot-lambda"
  }

}