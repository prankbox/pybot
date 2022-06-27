resource "aws_apigatewayv2_api" "lambda" {
  name          = "serverless_lambda_gw"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "lambda" {
  api_id = aws_apigatewayv2_api.lambda.id

  name        = "dev"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}

resource "aws_apigatewayv2_integration" "hello_world" {
  api_id = aws_apigatewayv2_api.lambda.id

  integration_uri    = module.bot_lambda.lambda_function_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "hello_world" {
  api_id = aws_apigatewayv2_api.lambda.id

  route_key = "POST /${var.route}"
  target    = "integrations/${aws_apigatewayv2_integration.hello_world.id}"
}

resource "aws_cloudwatch_log_group" "api_gw" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.lambda.name}"

  retention_in_days = 30
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.bot_lambda.lambda_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}

# resource "null_resource" "bot_webhook" {
#   provisioner "local-exec" {
#     command = <<EOF
#         curl --request POST --url https://api.telegram.org/bot${var.token}/setWebhook \
#         --header 'content-type: application/json' \
#         --data '{"url":"${aws_apigatewayv2_stage.lambda.invoke_url}/${var.route}}"}' \
        
# EOF
#   }
#   depends_on = [
#     aws_lambda_permission.api_gw,
#     aws_apigatewayv2_route.hello_world
#   ]
# }

# resource "local_file" "runner" {
#   filename = "runner.sh"
#   content = templatefile("runner.sh.tpl", {
#     token = var.token
#     url   = aws_apigatewayv2_stage.lambda.invoke_url
#     route = var.route

#   })
#   depends_on = [
#     aws_lambda_permission.api_gw,
#     aws_apigatewayv2_route.hello_world
#   ]
# }

# resource "null_resource" "bot_webhook" {
#   provisioner "local-exec" {
#     command = "./runner.sh"


#   }
#   depends_on = [
#     local_file.runner
#   ]

# }
