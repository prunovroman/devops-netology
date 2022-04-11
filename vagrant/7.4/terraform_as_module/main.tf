provider "aws" {
  region = var.region
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "3.5.0"

  for_each = local.instances[terraform.workspace]

  name = "app-server-${each.key}"

  ami                    = data.aws_ami.ubuntu.id
  instance_type          = each.value
  monitoring             = true
  vpc_security_group_ids = ["sg-0c3a866a7df722c37"]

}
