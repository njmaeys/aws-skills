# AWS-Skills  

## Terraform  
Version being used  
- Terraform v0.12.26  

Each subset of the repo has a terraform dir intended to serve as the launcher for the necessary resources.  

When it comes to security best practices I know there is a LOT I need to learn. Much of my time was spent 
learning and trying to integrate the tools. Continual learning is the best way I can manage to get the lacking
security best practices up to speed.

One thing I do know is that my permissions to roles are too open but I went with * permissions to be able to 
progress at a reasonable clip. More investment would need to be made to properly set only the permissions 
needed per service for the given role.

## Elasticsearch
The elasticsearch is defined in terraform but it made more sense to me to hook up the log groups manually.  

This tool is by far the strangest to me and I'm struggling to wrap my head around it. It would be nice if I could get to
the kibana view then maybe it would be easier to understand. In the interest of making forward progress I'm just setting
log groups to stream to it by manual configuration. There has to be something fundamental I'm just missing the mark on
that would make this whole tool way more understandable.

**From the Docs**  
https://docs.aws.amazon.com/elasticsearch-service/latest/developerguide/es-vpc.html#es-vpc-security
```
When you create a domain with VPC access, the endpoint looks similar to a public endpoint:

https://vpc-domain-name-identifier.region.es.amazonaws.com
If you try to access the endpoint in a web browser, however, you might find that the request times out. 
To perform even basic GET requests, your computer must be able to connect to the VPC. This connection often takes 
the form of a VPN, managed network, or proxy server. For details on the various forms it can take, see 
Scenarios and Examples in the Amazon VPC User Guide. For a development-focused example, see Testing VPC Domains.
```  
All that being said I'll try to create a VPN or a Proxy and see if i can connect that way. Beginning to get exhausted
and am going to throw in the towel at some point.

## Webserver
Running on Amazon Linux Images
- I think I'm going to make an AMI with the logger installed as there is setup that has to be done that I don't think I can manage progromatically.

AMI Setup
- See README in `ami_creation`

## Prowler

TODO - Put lambda that spins up ec2 on cron to run daily
- I think it makes sense to have the s3 bucket lambda kill the instance as well since it should be done if the file is in s3  

Prowler appears to be doing a lot of stuff. In the interest of time right now going to try to get results into cloudwatch regardless.  
I know there are going to be failures that it can't read at the moment but, I need to get logs flowing.

**Flow**  
Prowler dumps results to the git dir location in `/output/` so I can copy that to an S3 bucket after the results are done.
- The `run_prowler` lambda functions spins up and EC2 instance  
- The user data on the lambda downloads an execution script from s3  
- The execution script runs prowler with json flag set and then pushes results to S3 on completion  

**Run Logs**
This could have been done differently for sure but here is the process:  
- S3 bucket triggers a lambda function to push out the row items to cloudwatch logs
- The log group of the lambda function is then streamed to Elasticsearch via manual config on the log group  

Thought about trying out kinesis but it is not in the Free Tier, not goin to try but does seem interesting.  
