import boto3
import json


def  s3_to_es_prowler(event, context):

    for record in event['Records']:

        # Get the bucket name and key for the new file
        bucket = record['s3']['bucket']['name']
        key = record['s3']['object']['key']

        # Get, read, and split the file into lines
        obj = s3.get_object(Bucket=bucket, Key=key)
        body = obj['Body'].read()
        lines = body.splitlines()

    for line in lines:

        document = line.decode('utf8').replace("'", '"')
        print(document)

    return
