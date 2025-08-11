resource "aws_s3_bucket" "raw_images" {
  bucket = "${var.project_name}-raw-${random_id.bucket_suffix.hex}"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name = "${var.project_name}-raw"
  }
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}
