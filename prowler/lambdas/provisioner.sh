#!/bin/bash

apt update -y

echo "Move to the ec2 user dir"
cd /home/ec2-user/

echo "Download the prowler run script"
aws s3 cp s3://provisioner-scripts/run_prowler.sh ./
chmod +x ./run_prowler.sh

echo "Execute prowler"
./run_prowler.sh
