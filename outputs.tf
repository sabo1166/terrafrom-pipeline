output "bucket_name" {
  description = "Name of the existing bucket"
  value       = data.aws_s3_bucket.existing.id
}

output "bucket_arn" {
  description = "ARN of the existing bucket"
  value       = data.aws_s3_bucket.existing.arn
}

output "bucket_region" {
  description = "Region of the existing bucket"
  value       = data.aws_s3_bucket.existing.region
}
