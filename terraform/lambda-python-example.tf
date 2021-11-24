#resource "aws_cloudwatch_log_group" "python-example" {
#  provider = aws.secondary
#  name = "${local.app_name}-${var.environment}-python-example-logs"
#}
#
#resource "aws_lambda_permission" "python-example" {
#  statement_id  = "Allowpython-exampleLambdaInvoke"
#  action        = "lambda:InvokeFunction"
#  function_name = module.python-example-lambda.lambda_function_name
#  principal     = "apigateway.amazonaws.com"
#  source_arn    = "${module.python-example-api.apigatewayv2_api_execution_arn}/*/*/*"
#}
#
#module "python-example-lambda" {
#  source        = "terraform-aws-modules/lambda/aws"
#  function_name = "${var.app_name}-${var.environment}-python-example"
#  description   = "Provides a webhook for Slack user impersonation."
#  handler       = "handle.handle"
#  runtime       = "python3.8"
#  publish       = false
#  source_path   = "lambda-python-example/"
#  environment_variables = {
#    Serverless = "Terraform"
#  }
#  tags = {
#    CostCenter = "lambda-python-example"
#  }
#  attach_policy_statements = true
#  policy_statements = {
#    dynamodb = {
#      effect    = "Allow",
#      actions   = [
#         "dynamodb:GetItem",
#         "dynamodb:Query",
#         "dynamodb:UpdateItem"
#      ],
#      resources = [aws_dynamodb_table.global-store.arn]
#    }
#  }
#}
#
#module "python-example-api" {
#  source = "terraform-aws-modules/apigateway-v2/aws"
#
#  name          = "${local.app_domain}-python-example"
#  description   = "API Gateway for python-example Slack Bot"
#  protocol_type = "HTTP"
#
#  cors_configuration = {
#    allow_headers = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"]
#    allow_methods = ["*"]
#    allow_origins = ["*"]
#  }
#
#  # Custom domain
#  create_api_domain_name      = true
#  domain_name                 = join(".",["python-example",local.app_domain])
#  domain_name_certificate_arn = aws_acm_certificate.web-cert.arn
#
#  # Access logs
#  default_stage_access_log_destination_arn = aws_cloudwatch_log_group.python-example.arn
#  default_stage_access_log_format          = "$context.identity.sourceIp - - [$context.requestTime] \"$context.httpMethod $context.routeKey $context.protocol\" $context.status $context.responseLength $context.requestId $context.integrationErrorMessage"
#
#  # Routes and integrations
#  integrations = {
#    "POST /" = {
#      lambda_arn             = module.python-example-lambda.lambda_function_arn
#      payload_format_version = "2.0"
#      timeout_milliseconds   = 12000
#    }
#
#    "$default" = {
#      lambda_arn = module.python-example-lambda.lambda_function_arn
#    }
#  }
#  tags = {
#    Module = "lambda-web-mail"
#    Name = "web-mail-api"
#  }
#}
#
#resource "aws_route53_record" "python-example" {
#  depends_on = [module.python-example-api]
#  name    = join(".",["python-example",local.app_domain])
#  type    = "CNAME"
#  ttl     = 300
#  zone_id = aws_route53_zone.public.id
#  records = [module.python-example-api.apigatewayv2_domain_name_target_domain_name]
#}