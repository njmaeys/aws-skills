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
		"lambda:*",
		"s3:*"
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

# Prowler
resource "aws_lambda_function" "prowler" {

  filename         = "../bin/lambda.zip"
  function_name    = "run_prowler"
  runtime          = "python3.7"
  role             =  aws_iam_role.role_prowler.arn
  handler          = "lambda/launch_instance.launch_prowler"
  source_code_hash = filebase64sha256("../bin/lambda.zip")
  timeout          = 360

}

# S3 to ES
resource "aws_lambda_function" "s3_to_es" {

  filename         = "../bin/lambda.zip"
  function_name    = "s3_to_es"
  runtime          = "python3.7"
  role             =  aws_iam_role.role_prowler.arn
  handler          = "lambda/s3_to_es.s3_to_es_prowler"
  source_code_hash = filebase64sha256("../bin/lambda.zip")
  timeout          = 360
  layers           = ["arn:aws:lambda:us-west-2:883980837948:layer:python-pip-packages:1"]

  vpc_config {
      subnet_ids = [
        "subnet-b38e4fcb"
      ]

      security_group_ids = [
          "sg-6d37e93e"
      ]
  }

}

resource "aws_s3_bucket_notification" "prowler_log_trigger" {
    bucket = "prowler-log-results"

    lambda_function {
        lambda_function_arn = "${aws_lambda_function.s3_to_es.arn}"
        events              = ["s3:ObjectCreated:*"]
        filter_suffix       = ".json"
    }
}

resource "aws_lambda_permission" "prowler_trigger_permissions" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.s3_to_es.arn}"
  principal = "s3.amazonaws.com"
  source_arn = "arn:aws:s3:::prowler-log-results"
}
