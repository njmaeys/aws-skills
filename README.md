# AWS-Skills  

# TODOs  
- Clean up formatting!
- Try to break up the terraform templates

# Nice TODOs
- Deployment pipeline
- Controler functionality at top level

## Terraform  
Version being used  
- Terraform v0.12.26  

Each subset of the repo has a terraform dir intended to serve as the launcher for the necessary resources.

## Elasticsearch
The elasticsearch is defined in terraform but it made more sense to me to hook up the log groups manually.  
I've seen that there is data flowing to the elasticsearch but have not been able to access the kibana app.  

## Webserver
Running on Amazon Linux Images
- I think I'm going to make an AMI with the logger installed as there is setup that has to be done that I don't think I can manage progromatically.

AMI Setup

- curl https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py -O

- sudo python ./awslogs-agent-setup.py --region us-west-2

- Follow the prompts and use defaults
-- You don't need to set access keys or secrets

- Only need to add two things
-- log file location : `/var/log/httpd/access\_log`
-- cloud watch group : `webserver-access-logs`

Source for helping get logs pushed to cloudwatch:  
- https://devopscube.com/how-to-setup-and-push-serverapplication-logs-to-aws-cloudwatch/

## Prowler
Can likely put this behind a lambda function that spins up a micro EC2 on a cron scheduler.
I need to get it running first and figure out the right IAM role permissions it needs.
Then I need to see what it outputs and figure out how to get it to send that to cloudwatch.
- Maybe I can pump the results to a JSON file and then stream that as a payload with the cli?

Preliminary steps:
- sudo yum install git -y
- sudo yum install jq
- git clone https://github.com/toniblyx/prowler
- cd prowler
- ./prowler
