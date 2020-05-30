provider "aws" {
    region = "us-west-2"
    profile = "njmaeys"
}

######### ELB #########
# TODO 
# Set up the ELB and ensure that the ec2 instance below is configured in it


######### EC2 INSTANCE #########
# TODO
# Set up a user data profile to be able to install the webserver and launch it

data "aws_vpc" "main" {
    tags = {
        Name = "main"
    }
}

data "aws_ami" "ubuntu" {

    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"]

}

data "aws_subnet" "selected" {
    vpc_id = "vpc-1d7e0a65"
    id = "subnet-21f8287c"
}

data "aws_security_group" "selected" {
  filter {
    name   = "group-name"
    values = ["allow_tls"]
  }
}

resource "aws_instance" "web" {

    ami = "${data.aws_ami.ubuntu.id}"
    instance_type = "t2.micro"

    vpc_security_group_ids = [data.aws_security_group.selected.id]

    tags = {
        Name = "WebServer"
    }

    key_name = "general_ssh"

}

