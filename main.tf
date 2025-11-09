resource "aws_s3_bucket" "main" {
  bucket        = "tf-book-covers"
  force_destroy = true
  tags = {
    "Name" = "Book Covers"
  }
}

resource "aws_s3_object" "jp-tlw" {
  bucket       = aws_s3_bucket.main.id
  content_type = "image/jpeg"
  key          = "book-covers/jp-tlw.jpg"
  source       = "${path.module}/book-covers/jp-tlw.jpg"
}

resource "aws_s3_object" "nfu" {
  bucket       = aws_s3_bucket.main.id
  content_type = "image/jpeg"
  key          = "book-covers/nfu.jpg"
  source       = "${path.module}/book-covers/nfu.jpg"
}

resource "aws_s3_object" "tsp" {
  bucket       = aws_s3_bucket.main.id
  content_type = "image/jpeg"
  key          = "book-covers/tsp.jpg"
  source       = "${path.module}/book-covers/tsp.jpg"
}

resource "aws_s3_object" "mos" {
  bucket       = aws_s3_bucket.main.id
  content_type = "image/jpeg"
  key          = "book-covers/mos.jpg"
  source       = "${path.module}/book-covers/mos.jpg"
}

resource "aws_s3_object" "book_json" {
  bucket       = aws_s3_bucket.main.id
  content_type = "application/json"
  key          = "book.json"
  source       = "${path.module}/book.json"
}


resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.main.id
  block_public_acls       = false
  block_public_policy     = false
  restrict_public_buckets = false
  ignore_public_acls      = false
}

resource "aws_s3_bucket_policy" "main" {
  depends_on = [aws_s3_bucket_public_access_block.public_access]
  bucket     = aws_s3_bucket.main.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{ Effect = "Allow"
      Principal = "*"
      Action    = ["s3:GetObject"]
      Resource  = ["${aws_s3_bucket.main.arn}/*"]
    }]
  })
}

resource "aws_s3_bucket_cors_configuration" "cors" {
  bucket = aws_s3_bucket.main.id

  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    allowed_headers = ["*"]
  }
}

resource "aws_s3_bucket_versioning" "name" {
  bucket = aws_s3_bucket.main.id
  versioning_configuration {
    status = "Enabled"
  }
}
