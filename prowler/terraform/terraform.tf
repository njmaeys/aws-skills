provider "aws" {
    region  = "us-west-2"
    profile = "njmaeys"
}

######### ROLE AND POLICY #########

resource "aws_iam_role" "role_prowler" {

  name  = "role_prowler"
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

resource "aws_iam_role_policy" "policy_prowler" {

  name   = "policy_prowler"
  role   = aws_iam_role.role_prowler.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
		"iam:*",
		"logs:*",
		"ec2:*",
		"lambda:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF

}

resource "aws_iam_instance_profile" "prowler_profile" {
  name = "prowler_profile"
  role = "${aws_iam_role.role_prowler.name}"
}

######### LAMBDA #########

resource "aws_lambda_function" "prowler" {

  filename         = "../bin/lambda.zip"
  function_name    = "run_prowler"
  runtime          = "python3.7"
  role             =  aws_iam_role.role_prowler.arn
  handler          = "lambda/launch_instance.launch_prowler"
  source_code_hash = filebase64sha256("../bin/lambda.zip")
  timeout          = 360

}
