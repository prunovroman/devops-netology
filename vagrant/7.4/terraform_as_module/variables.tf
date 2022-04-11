locals {
  instances = {
    stage = {
      vm1 = "t2.micro"
    },
    prod = {
      vm1 = "t2.small",
      vm2 = "t2.large"
    }
  }
}

variable "region" {
  description = "Input aws region info"
  type        = string
  default     = "us-east-1"
}


