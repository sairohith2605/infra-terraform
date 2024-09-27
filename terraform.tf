terraform {
  backend "s3" {
    key    = "global/s3/terraform.tfstate"
    region = "ap-south-1"

    dynamodb_table = "tf-state-s3-dynamo-locks"
    encrypt        = true
  }
}


module "tf-state-backend-s3" {
    source = "./tfinternal"
    s3_state_bucket = var.s3_state_bucket
}
