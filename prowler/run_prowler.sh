#!/bin/bash

# install tools
sudo yum install git -y
sudo yum install jq -y

# download the repo
git clone https://github.com/toniblyx/prowler

# run it
/home/ec2-user/prowler/prowler -M json

# copy results out
aws s3 cp /home/ec2-user/prowler/output/prowler-output-*.json s3://prowler-log-results
