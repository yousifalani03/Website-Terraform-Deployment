provider "aws" {
    region = "us-west-1"
}

resource "aws_s3_bucket" "nextjs_bucket" {
    bucket = "ya-portfolio-bucket"

    tags = {
        Name = "Portfolio Website"
        Environment = "Production"
    }

}

resource "aws_s3_bucket_ownership_controls" "nextjs_bucket_ownership_controls" {
    bucket = aws_s3_bucket.nextjs_bucket.id

    rule {
        object_ownership = "BucketOwnerPrefferred" #gives complete control of bucket
    }
}

resource "aws_s3_bucket_public_access_block" "nextjs_bucket_public_access_block" {
    bucket = aws_s3_bucket.nextjs_bucket.id

    block_public_acls = false
    block_public_policy = false
    ignore_public_acls = false
    restrict_public_buckets = false
}

#Bucket ACL
resource "aws_s3_bucket_acl" "nextjs_bucket_acl" {
    depends_on = [
        aws_s3_bucket_ownership_controls.nextjs,
        aws_s3_bucket_public_access_block.nextjs_bucket_public_access_block
    ]
    bucket = aws_s3_bucket.nextjs_bucket.id
    acl = "public-read" #allows all to read inside bucket
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

resource "aws_s3_bucket_policy" "nextjs_bucket_policy" {
    bucket = aws_s3_bucket.nextjs_bucket.id
    #allows all access to objects in bucket
    policy = jsonencode({
        Version = 2012-10-17
        Statement = [
            {
                Sid = "PublicReadGetObject"
                Effect = "Allow"
                Principal = "*" #* means for all users
                Action = "s3:GetObject"
                Resource = "${aws_s3_bucket.nextjs_bucket.arn}/*"
            }
        ]
    })
}

