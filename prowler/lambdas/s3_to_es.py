import boto3
import json


def parse_instances(response):

    instance_id_list = []
    
    reservations = response['Reservations']
    
    for r in reservations:
        for i in r['Instances']:
            instance_id_list.append(i['InstanceId'])

    return instance_id_list

def list_instances(ec2_client, instance_name):

    response = ec2_client.describe_instances(
            Filters=[
                {
                    'Name': 'tag:Name',
                    'Values': [
                        instance_name
                    ]
                },
            ]
        )

    return response

def destroyer(instance_name):

    ec2_client = boto3.client('ec2')

    instance_search_response = list_instances(ec2_client, instance_name)

    instance_ids = parse_instances(instance_search_response)

    # Terminate any of the running instances
    response = ec2_client.terminate_instances(
            InstanceIds=instance_ids
        )

    return

def  s3_to_es_prowler(event, context):

    # Going to let this function call terminate the prowler ec2 instance
    destroyer('Prowler')

    s3_client = boto3.client('s3')

    for record in event['Records']:

        # Get the bucket name and key for the new file
        bucket = record['s3']['bucket']['name']
        key = record['s3']['object']['key']

        # Get, read, and split the file into lines
        obj = s3_client.get_object(Bucket=bucket, Key=key)
        body = obj['Body'].read()
        lines = body.splitlines()

    for line in lines:

        document = line.decode('utf8').replace("'", '"')
        print(document)

    return
