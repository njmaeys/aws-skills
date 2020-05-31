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
Prowler appears to be doing a lot of stuff. In the interest of time right now going to try to get results into cloudwatch regardless.  
I know there are going to be failures that it can't read at the moment but, I need to get logs flowing.

Thought about trying out kinesis but it is not in the Free Tier, not goin to try but does seem interesting.  

Prowler dumps results to the git dir location in `/output/` so I can copy that to an S3 bucket after the results are done.

TODO - Put lambda that spins up ec2 on cron to run daily
TODO - Need to figure out a way to terminate EC2 instance on completion - SNS on bucket push?
Flow:  
- The `run_prowler` lambda functions spins up and EC2 instance  
- The user data on the lambda downloads an execution script from s3  
- The execution script runs prowler with json flag set and then pushes results to S3 on completion  
