#!/bin/bash

# project setup
projectSetup() {

	echo
	echo "Running virtualenv setup."
	virtualenv -p python3 ./.venv

	echo
	echo "Running virtualenv pip installation."
	./.venv/bin/pip install -r ./lambda/requirements.txt
}

# compress
compress() {

	echo
	echo "compress the project"
	if [ -d "./bin" ]; then
		echo "bin dir exists"
	else
		echo "bin dir does not exists: creating"
		mkdir ./bin
	fi
	zip -r ./bin/lambda.zip lambda -x *venv* *__pycache__*

}

# push provision to s3
pushProvisionerToS3() {

	echo
	echo "Push provisioner to s3"

	cmd="aws s3 cp ./run_prowler.sh s3://provisioner-scripts/run_prowler.sh --profile $1 --region us-west-2"
    $cmd
}

########### usage ###########
usage="$(basename "$0") 

Parameters that you may use include:

[ -h ] [ -c ]

options:
    -h    show this help text
    -s    set up the virtualenv and install deps
    -c    compress the lambda into the zip for deployment
    -p    push provisioner script to s3"

while getopts 'hscp:' o; do
	case "${o}" in
		h) 
			echo "$usage"
			exit
			;;
		s) 
			projectSetup
			;;
		c) 
			compress
			;;
		p) 
			pushProvisionerToS3 ${OPTARG}
			;;
		\?)
			echo "$usage"
			;;
	esac
done
shift $((OPTIND - 1))
