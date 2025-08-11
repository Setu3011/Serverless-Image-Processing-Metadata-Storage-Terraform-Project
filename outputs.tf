output "s3_bucket_name" {
  value = aws_s3_bucket.raw_images.bucket
}

output "lambda_function_name" {
  value = aws_lambda_function.image_processor.function_name
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.image_metadata.name
}
