output "primary_region" {
  description = "The primary region for app serving."
  value       = var.primary_region
}
output "secondary_region" {
  description = "Hosts failover copy of app & CloudFront/ACM configuration."
  value       = var.secondary_region
}
output "web-primary-bucket" {
  description = "Primary Web Bucket"
  value       = aws_s3_bucket.web-primary.arn
}
output "web-secondary-bucket" {
  description = "Primary Web Bucket"
  value       = aws_s3_bucket.web-secondary.arn
}
output "web-logs-bucket" {
  description = "Primary Web Bucket"
  value       = aws_s3_bucket.web-logs.arn
}

# Lambda Function ----------------------------------------------------------

#output "lambda_function_arn" {
#  description = "The ARN of the Lambda Function"
#  value       = module.lambda_function.lambda_function_arn
#}
#
#output "lambda_function_invoke_arn" {
#  description = "The Invoke ARN of the Lambda Function"
#  value       = module.lambda_function.lambda_function_invoke_arn
#}
#
#output "lambda_function_name" {
#  description = "The name of the Lambda Function"
#  value       = module.lambda_function.lambda_function_name
#}
#
#output "lambda_function_qualified_arn" {
#  description = "The ARN identifying your Lambda Function Version"
#  value       = module.lambda_function.lambda_function_qualified_arn
#}
#
#output "lambda_function_version" {
#  description = "Latest published version of Lambda Function"
#  value       = module.lambda_function.lambda_function_version
#}
#
#output "lambda_function_last_modified" {
#  description = "The date Lambda Function resource was last modified"
#  value       = module.lambda_function.lambda_function_last_modified
#}
#
#output "lambda_function_kms_key_arn" {
#  description = "The ARN for the KMS encryption key of Lambda Function"
#  value       = module.lambda_function.lambda_function_kms_key_arn
#}
#
#output "lambda_function_source_code_hash" {
#  description = "Base64-encoded representation of raw SHA-256 sum of the zip file"
#  value       = module.lambda_function.lambda_function_source_code_hash
#}
#
#output "lambda_function_source_code_size" {
#  description = "The size in bytes of the function .zip file"
#  value       = module.lambda_function.lambda_function_source_code_size
#}
#output "lambda_role_arn" {
#  description = "The ARN of the IAM role created for the Lambda Function"
#  value       = module.lambda_function.lambda_role_arn
#}
#output "lambda_role_name" {
#  description = "The name of the IAM role created for the Lambda Function"
#  value       = module.lambda_function.lambda_role_name
#}
#output "lambda_cloudwatch_log_group_arn" {
#  description = "The ARN of the Cloudwatch Log Group"
#  value       = module.lambda_function.lambda_cloudwatch_log_group_arn
#}
#output "local_filename" {
#  description = "The filename of zip archive deployed (if deployment was from local)"
#  value       = module.lambda_function.local_filename
#}
#output "api_path" {
#  description = "API Path"
#  value       = module.api_gateway.apigatewayv2_api_api_endpoint
#}