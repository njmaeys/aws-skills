import boto3
import os


def  launch_prowler(event, context):
    # TODO this will be how i can configure the instance to do things on launch
    #UserData=open("/var/task/lambda/provision.sh").read(),

    ec2_client = boto3.client('ec2')

    r = ec2_client.run_instances(
        ImageId='ami-086b16d6badeb5716',
        InstanceType='t2.micro',
        DisableApiTermination=False,
        SubnetId='subnet-b38e4fcb',
        MinCount=1,
        MaxCount=1,
        TagSpecifications=[
            {
                'ResourceType': 'instance',
                'Tags':[
                    {'Key': 'Name',
                    'Value': 'Prowler'}
                ]
            }
        ],
        SecurityGroupIds=[
           'sg-0562d424164d60a17'
        ],
        InstanceInitiatedShutdownBehavior='terminate',
        IamInstanceProfile={
            'Arn': 'arn:aws:iam::883980837948:instance-profile/web_profile'
        },
        KeyName='general_ssh'
    )

    print(r)

    return
