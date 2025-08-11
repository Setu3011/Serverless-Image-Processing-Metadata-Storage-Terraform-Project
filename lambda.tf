data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_src"
  output_path = "${path.module}/lambda_build/${var.project_name}_lambda.zip"
}

resource "null_resource" "ensure_build_dir" {
  provisioner "local-exec" {
    command = "mkdir -p ${path.module}/lambda_build"
  }
}

resource "aws_lambda_function" "image_processor" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "${var.project_name}-processor"
  role             = aws_iam_role.lambda_role.arn
  handler          = "handler.lambda_handler"
  runtime          = "python3.9"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  timeout          = 30
  memory_size      = 256
  depends_on       = [null_resource.ensure_build_dir, aws_iam_role_policy_attachment.attach_lambda_policy]
}

resource "aws_lambda_permission" "allow_s3_invoke" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.image_processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn = aws_s3_bucket.raw_images.arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.raw_images.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.image_processor.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix = "uploads/"
  }

  depends_on = [aws_lambda_permission.allow_s3_invoke]
}
