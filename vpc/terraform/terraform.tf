provider "aws" {
    region  = var.region
    profile = "njmaeys"
}

######### VPC #########

resource "aws_vpc" "main" {

    cidr_block = "10.0.0.0/16"

    instance_tenancy = "dedicated"

    tags = {
        Name = "w2-main"
    }
}

