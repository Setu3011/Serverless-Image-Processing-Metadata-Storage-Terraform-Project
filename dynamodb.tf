resource "aws_dynamodb_table" "image_metadata" {
  name         = "${var.project_name}-metadata"
  billing_mode = "PAY_PER_REQUEST"

  hash_key  = "image_id"
  range_key = "upload_time"

  attribute {
    name = "image_id"
    type = "S"
  }

  attribute {
    name = "upload_time"
    type = "S"
  }

  tags = {
    Name = "${var.project_name}-metadata"
  }
}
