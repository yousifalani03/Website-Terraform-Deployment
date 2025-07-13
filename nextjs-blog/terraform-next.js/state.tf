terraform {
    backend "s3" {
        bucket = "ya-my-tf-website-state"
        key = "global/s3/terraform.tfstate"
        region = "us-west-1"
        dynamodb_table = "my-db-website-table"
    }
}