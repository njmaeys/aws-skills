provider "aws" {
    region  = "us-west-2"
    profile = "njmaeys"
}

resource "aws_elasticsearch_domain" "web_logs" {
  domain_name           = "web-logs-es-domain"
  elasticsearch_version = "7.4"

  cluster_config {
    instance_type = "t2.small.elasticsearch"
    instance_count = 1
  }

  ebs_options {
      ebs_enabled = true
      volume_size = 10
  }

  vpc_options {
    subnet_ids = [
      "subnet-b38e4fcb"
    ]

    security_group_ids = [
        "sg-0bf0e26a9805f0d02"
    ]
  }

  snapshot_options {
    automated_snapshot_start_hour = 23
  }

  tags = {
    Domain = "WebLogsEsDomain"
  }
}
