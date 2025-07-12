provider "aws" {
    region = "us-west-1"
}

resource "aws_s3_bucket" "website" {
    bucket = "ya-portfolio-bucket"

    tags = {
        Name = "Portfolio Website"
        Environment = "Production"
    }

}

resource "aws_s3_bucket_website_configuration" "ya-nextjs-config" {
    bucket = aws_s3_bucket.website.id

    index_document {
        suffix = "index.html"
    }
    error_document {
        key = "error.html"
    }

}

resource "aws_s3_bucket_policy" "allow_access_from_other_account" {
    bucket = aws_s3_bucket.website.id

    policy = jsonencode({
        Version = 2012-10-17
        Statement = [
            {
                Effect = "Allow"
                Principal = "*"
                Action = "s3:GetObject"
                Resource = "${aws_s3_bucket.website.arn}/*"
            }
        ]
    })
}

