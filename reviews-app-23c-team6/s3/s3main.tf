resource "aws_s3_bucket" "project_bucket" {
  bucket = var.failover_bucket_name
}

# Set ownership controls
resource "aws_s3_bucket_ownership_controls" "project_bucket" {
  bucket = aws_s3_bucket.project_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Enable public access block
resource "aws_s3_bucket_public_access_block" "project_bucket" {
  bucket = aws_s3_bucket.project_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Set ACL
resource "aws_s3_bucket_acl" "project_bucket" {
  depends_on = [
    aws_s3_bucket_ownership_controls.project_bucket,
    aws_s3_bucket_public_access_block.project_bucket
  ]
  bucket = aws_s3_bucket.project_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "project_bucket_policy" {
  depends_on = [aws_s3_object.maintenance_object]
  bucket     = aws_s3_bucket.project_bucket.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "PublicReadGetObject",
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : [
          "s3:GetObject"
        ],
        "Resource" : [
          "arn:aws:s3:::${var.failover_bucket_name}/*"
        ]
      }
    ]
  })
}

# Website configuration 
resource "aws_s3_bucket_website_configuration" "website_configutation" {
  bucket = aws_s3_bucket.project_bucket.id
  index_document {
    suffix = "maintenance.html"
  }
}

resource "aws_s3_object" "maintenance_object" {
  bucket              = aws_s3_bucket.project_bucket.bucket
  key                 = "maintenance.html"
  source              = "${path.module}/maintenance.html"
  content_type        = "text/html"
  content_disposition = "inline"
}
