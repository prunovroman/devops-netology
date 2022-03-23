provider "aws" {
  shared_config_files      = ["/home/vagrant/.aws/config"]
  shared_credentials_files = ["/home/vagrant/.aws/credentials"]
  profile                  = "Administrator"
  region                   = "us-east-1"
}

data "aws_ami" "ubuntu" {    
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/ubuntu-*-*-amd64-server-*"]
   }

   owners = ["099720109477"]
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  cpu_core_count = 16
  private_ip = "192.168.1.100"

  tags = {
    Name = "Netology"
  }
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}