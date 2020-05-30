provider "aws" {
    region  = var.region
    profile = "njmaeys"
}

######### ELB #########
# TODO 
# Set up the ELB and ensure that the ec2 instance below is configured in it


data "aws_vpc" "main" {
    tags = {
        Name = "w2-main"
    }
}


######### SECURITY GROUP #########

resource "aws_security_group" "allow_tls" {

    name = "allow_tls"

    description = "Allow TLS"

    vpc_id = "vpc-1d7e0a65"

    ingress {
        description = "SSH from VPC"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [
            data.aws_vpc.main.cidr_block,
            "172.31.0.0/16",
            "76.92.128.2/32"
        ]
    }

    ingress {
        description = "HTTP access"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "allow_TLS"
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


######## INSTANCES ###########
# ONE
resource "aws_instance" "web1" {

    ami           = data.aws_ami.selected_aws_linux.id
    instance_type = "t2.micro"

    subnet_id = "subnet-b38e4fcb"
    vpc_security_group_ids = [
        "${aws_security_group.allow_tls.id}"
    ]

    tags = {
        Name    = "server-one",
        Product = "WebServer"
    }

    user_data = "${file("../launch_webserver.sh")}"

    key_name = "general_ssh"

}

# TWO
resource "aws_instance" "web2" {

    ami           = data.aws_ami.selected_aws_linux.id
    instance_type = "t2.micro"

    subnet_id = "subnet-c404e78e"
    vpc_security_group_ids = [
        "${aws_security_group.allow_tls.id}"
    ]

    tags = {
        Name    = "server-two",
        Product = "WebServer"
    }

    user_data = "${file("../launch_webserver.sh")}"

    key_name = "general_ssh"

}

####### ELB #####

resource "aws_elb" "web_elb" {

  name               = "web-elb"
  availability_zones = ["us-west-2a", "us-west-2b"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  instances                   = [
        "${aws_instance.web1.id}",
        "${aws_instance.web2.id}",
    ]

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:80"
    interval            = 15
  }

  tags = {
    Name = "web-elb"
  }
}
