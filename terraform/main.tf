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
  instance_type = local.instance_type_map[terraform.workspace]
  count = local.instance_count_map[terraform.workspace]
  tags = {
    Name = "Netology ${count.index + 1 }"
  }
}

resource "aws_instance" "web1" {
  for_each = local.instances[terraform.workspace]
  
  ami           = data.aws_ami.ubuntu.id
  instance_type = each.value
  tags = {
    Name = each.key
  }
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}