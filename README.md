# Serverless Image Metadata — Deploy Steps

## Prerequisites
- Terraform 1.2+
- AWS CLI configured with credentials
- Python 3.9+

## Deploy
1. Clone/download this repo.
2. cd into the repo folder.
3. (Optional) edit `variables.tf` defaults.
4. Run `terraform init`.
5. Run `terraform apply -auto-approve`.

## Test
1. Upload file to S3 bucket (check output for bucket name).
2. Check CloudWatch logs and DynamoDB table for metadata.
