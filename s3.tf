resource "aws_s3_bucket" "tf_bucket" {
  bucket = "jenkins-s3-web"
}

resource "aws_s3_bucket_public_access_block" "s3-access-control" {
  bucket = aws_s3_bucket.tf_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
  depends_on = [ aws_s3_bucket.tf_bucket ]
}


resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.tf_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "example" {
  depends_on = [aws_s3_bucket_ownership_controls.example ]

  bucket = aws_s3_bucket.tf_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_object" "s3_obj" {
  bucket       = aws_s3_bucket.tf_bucket.id
  key          = "index.html"
  source       = "index.html"
  content_type = "text/html"
  acl          = "public-read"

depends_on = [ aws_s3_bucket_acl.example ]
}


resource "aws_s3_bucket_website_configuration" "web_config" {
  bucket = aws_s3_bucket.tf_bucket.id

  index_document {
    suffix = "index.html"
  }
  depends_on = [ aws_s3_bucket.tf_bucket ]
}
