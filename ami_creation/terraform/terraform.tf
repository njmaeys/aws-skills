provider "aws" {
  region  = "us-west-2"
  profile = "njmaeys"
}

data "aws_vpc" "main" {
  tags = {
    Name = "w2-main"
  }
}

data "aws_security_group" "allow_tls"{
  tags = {
    Name = "allow_tls"
  }
}

data "aws_ami" "selected_aws_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "description"
    values = ["Amazon Linux AMI 2018.*"]
  }
}

######## INSTANCE ###########
resource "aws_instance" "web1" {

  ami           = data.aws_ami.selected_aws_linux.id
  instance_type = "t2.micro"

  iam_instance_profile = "arn:aws:iam::883980837948:instance-profile/web_profile"
  subnet_id = "subnet-b38e4fcb"
  vpc_security_group_ids = [
    data.aws_security_group.allow_tls.id
  ]

  tags = {
    Name    = "server-one",
    Product = "WebServer"
  }

  user_data = "${file("../launch_webserver.sh")}"

  key_name = "general_ssh"

}
