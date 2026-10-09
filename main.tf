# Read-only reference to the EXISTING bucket. Terraform never creates, modifies,
# replaces or deletes it. Promote to a managed resource only after the manual
# inspection + import steps in README.md.
data "aws_s3_bucket" "existing" {
  bucket = var.bucket_name
}
