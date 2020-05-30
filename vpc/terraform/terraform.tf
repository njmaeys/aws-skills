provider "aws" {
    region  = "us-west-2"
    profile = "njmaeys"
}

######### VPC #########

resource "aws_vpc" "main" {

    cidr_block = "10.0.0.0/16"

    instance_tenancy = "dedicated"

    tags = {
        Name = "main"
    }
}

######### SUBNET #########

resource "aws_subnet" "main" {
    vpc_id     = "${aws_vpc.main.id}"
    cidr_block = "10.0.1.0/24"

    tags = {
        Name = "Main"
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
            aws_vpc.main.cidr_block,
            "76.92.128.2/32"
        ]
    }

    ingress {
        description = "HTTP access"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = [
            aws_vpc.main.cidr_block,
            "76.92.128.2/32"
        ]
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
