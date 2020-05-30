# AWS-Skills  

# TODOs  
- Clean up formatting!
- Potentially Kinesis to get logs to s3
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

**Logs**
- `/var/log/httpd/access_log`
- TODO - get them to cloudwatch
- TODO - get elasticsearch to read them
