provider "aws" {
    region  = "us-west-2"
    profile = "njmaeys"
}

######### ELB #########

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

  owners = ["883980837948"]

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "name"
    values = ["aws-skills-web-ami"]
  }
}


######## INSTANCES ###########
# ONE
resource "aws_instance" "web1" {

    ami           = data.aws_ami.selected_aws_linux.id
    instance_type = "t2.micro"

    iam_instance_profile = "${aws_iam_instance_profile.web_profile.id}"
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

    iam_instance_profile = "${aws_iam_instance_profile.web_profile.id}"
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

########### IAM ROLE #########
resource "aws_iam_instance_profile" "web_profile" {
  name = "web_profile"
  role = "${aws_iam_role.web_role.name}"
}

resource "aws_iam_role" "web_role" {
  name = "web-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "main_policy" {
  name        = "main-policy"
  description = "My main policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:*",
        "logs:*",
        "iam:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "main_attach" {
  role       = "${aws_iam_role.web_role.name}"
  policy_arn = "${aws_iam_policy.main_policy.arn}"
}

####################

resource "aws_iam_instance_profile" "stream_profile" {
  name = "stream_profile"
  role = "${aws_iam_role.stream_role.name}"
}

resource "aws_iam_role" "stream_role" {
  name = "stream-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "stream_policy" {
  name        = "stream-policy"
  description = "My stream policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "es:*",
        "lambda:*",
        "lambda:AWSLambdaVPCAccessExecutionRole"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "stream_attach" {
  role       = "${aws_iam_role.stream_role.name}"
  policy_arn = "${aws_iam_policy.stream_policy.arn}"
}
