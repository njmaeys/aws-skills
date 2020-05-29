provider "aws" {
    region = "us-west-2"
    profile = "njmaeys"
}

resource "aws_vpc" "main" {
    cidr_block       = "10.0.0.0/16"
    instance_tenancy = "dedicated"

    tags = {
        Name = "main"
    }
}
