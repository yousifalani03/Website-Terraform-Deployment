provider "aws" {
    region = "us-west-1"
}

resource "aws_s3_bucket" "nextjs_bucket" {  #s3 bucket to host static website
    bucket = "nextjs-portfolio-bucket-ya"
}

resource "aws_s3_bucket_ownership_controls" "nextjs_bucket_ownership_controls" {
    bucket = aws_s3_bucket.nextjs_bucket.id

    rule {
        object_ownership = "BucketOwnerPreferred" #gives complete control of bucket objects to only owner
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
        aws_s3_bucket_ownership_controls.nextjs_bucket_ownership_controls,
        aws_s3_bucket_public_access_block.nextjs_bucket_public_access_block
    ]
    bucket = aws_s3_bucket.nextjs_bucket.id
    acl = "public-read" #allows all to read inside bucket
}


resource "aws_s3_bucket_policy" "nextjs_bucket_policy" {
    bucket = aws_s3_bucket.nextjs_bucket.id
    #allows all access to objects in bucket
    policy = jsonencode({
        Version = "2012-10-17"
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


#Origin Access Identity
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
    comment = "OAI for next.js portfolio site"
}

#Cloudfront distribution
resource "aws_cloudfront_distribution" "nextjs_distribution" { #CloudFront distribution to serve the content globally with caching and HTTPS.
    origin {
        domain_name = aws_s3_bucket.nextjs_bucket.bucket_regional_domain_name #tells cloudfront where to fetch content from
        origin_id = "S3-ya-nextjs-portfolio-bucket"

        s3_origin_config {
          origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
        } #Linked the S3 bucket to CloudFront using an Origin Access Identity (OAI) to secure the bucket
    }

    enabled = true
    is_ipv6_enabled = true
    comment = "Next.js portfolio site"
    default_root_object = "index.html"

    default_cache_behavior {
      allowed_methods = ["GET", "HEAD", "OPTIONS"]
      cached_methods = ["GET", "HEAD"]
      target_origin_id = "S3-ya-nextjs-portfolio-bucket"

      forwarded_values {
        query_string = false
        cookies {
          forward = "none"
        }
      }

      viewer_protocol_policy = "redirect-to-https"
      min_ttl = 0
      default_ttl = 3600
      max_ttl = 86400
    }

    restrictions {
        geo_restriction {
          restriction_type = "none"
        }
    }

    viewer_certificate {
        cloudfront_default_certificate = true #tells cf to use default ssl and tsl certs
    }
}