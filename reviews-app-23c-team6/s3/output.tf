output "s3_bucket_url" {
  description = "url of the bucket"
  value       = "https://${aws_s3_bucket.project_bucket.bucket}.s3.amazonaws.com/maintenance.html"
}
# https://project-bucket-124433.s3.amazonaws.com/maintenance.html
