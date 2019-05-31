terraform {
  backend "s3" {
    bucket         = "tf-state-041dbd9c329872aa10e43f2d952b65017202a5f8577ae23be70"
    region         = "us-west-1"
    key            = "us-west-2/carrot-org/carrot-vpc-foundation/stack.tfstate"
    encrypt        = true
  }
}