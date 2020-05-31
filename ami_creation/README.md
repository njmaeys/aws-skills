# AMI Creation
This is used for the webserver.

You should launch the instance with Terraform then follow the instructions at the following link.  
- https://devopscube.com/how-to-setup-and-push-serverapplication-logs-to-aws-cloudwatch/

The general instructions are this in case the link doesn't work
- curl https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py -O
- sudo python ./awslogs-agent-setup.py --region us-west-2

Follow the prompts and use defaults  
- You don't need to set access keys or secrets

Only need to add two things during prompts look for:  
- log file location : `/var/log/httpd/access\_log`  
- cloud watch group : `webserver-access-logs`  
