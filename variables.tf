variable "aws_region" {
  description = "AWS region of the existing bucket"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Name of the existing S3 bucket"
  type        = string
  default     = "terrafrom-s3-pipeline"
}
