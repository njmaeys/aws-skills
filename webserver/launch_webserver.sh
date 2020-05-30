#! /bin/bash

sudo yum update -y
sudo yum install -y httpd24 php56 php56-mysqlnd
sudo service httpd start
