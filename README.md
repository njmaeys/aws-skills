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

## Webserver
Running on Amazon Linux Images
- I think I'm going to make an AMI with the logger installed as there is setup that has to be done that I don't think I can manage progromatically.

AMI Setup

- curl https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py -O

- sudo python ./awslogs-agent-setup.py --region us-west-2

- Follow the prompts and use defaults
-- You don't need to set access keys or secrets

- Only need to add two things
-- log file location : /var/log/httpd/access_log
-- cloud watch group : webserver-access-logs

**Logs**
- `/var/log/httpd/access_log`
- TODO - get them to cloudwatch
- TODO - get elasticsearch to read them
