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

########### usage ###########
usage="$(basename "$0") 

Parameters that you may use include:

[ -h ] [ -c ]

options:
    -h    show this help text
    -s    set up the virtualenv and install deps
    -c    compress the lambda into the zip for deployment"

while getopts 'hsc' o; do
    # reminder to use --> if i want to add in an argument ${OPTARG}
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
		\?)
			echo "$usage"
			;;
	esac
done
shift $((OPTIND - 1))
