terraform {
  backend "s3" {
    bucket         = "cloud-final-tfstate-991346768340"
    key            = "dev/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "cloud-final-tflock"
    encrypt        = true
  }
}
