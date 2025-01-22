terraform {
  backend "s3" {
    bucket         = "week6-jp-bucket"
    key            = "week-10/terraform.tf"
    region         = "us-east-2"
    dynamodb_table = "terraform-lock"
    encrypt        = true


  }
}