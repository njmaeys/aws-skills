provider "aws" {
    region = "us-west-2"
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

######### SECURITY GROUP #########

resource "aws_security_group" "allow_tls" {

    name        = "allow_tls"

    description = "Allow TLS"

    vpc_id      = "${aws_vpc.main.id}"

    ingress {
        description = "SSH from VPC"
        from_port = 22
        to_port = 22
        protocol= "tcp"
        cidr_blocks = [aws_vpc.main.cidr_block]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "allow_TLS"
    }
}
