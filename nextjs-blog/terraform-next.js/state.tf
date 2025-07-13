terraform {
    backend "s3" {
        bucket = "ya-nextjs-web"
        key = "global/s3/terraform.tfstate"
        region = "us-west-1"
        dynamodb_table = "terraform-lock-file"
    }
}