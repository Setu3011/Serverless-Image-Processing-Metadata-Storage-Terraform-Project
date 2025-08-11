data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "${var.project_name}-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

data "aws_iam_policy_document" "lambda_policy" {
  statement {
    sid    = "logs"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }

  statement {
    sid    = "s3-get"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:ListBucket",
      "s3:HeadObject",
    ]
    resources = [
      aws_s3_bucket.raw_images.arn,
      "${aws_s3_bucket.raw_images.arn}/*",
    ]
  }

  statement {
    sid    = "dynamodb-put"
    effect = "Allow"
    actions = [
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:DescribeTable",
    ]
    resources = [aws_dynamodb_table.image_metadata.arn]
  }
}

resource "aws_iam_policy" "lambda_policy" {
  name   = "${var.project_name}-lambda-policy"
  policy = data.aws_iam_policy_document.lambda_policy.json
}

resource "aws_iam_role_policy_attachment" "attach_lambda_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}
