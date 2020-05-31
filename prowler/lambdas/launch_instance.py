import boto3
import os


def  launch_prowler(event, context):

    ec2_client = boto3.client('ec2')

    r = ec2_client.run_instances(
        ImageId='ami-086b16d6badeb5716',
        InstanceType='t2.micro',
        DisableApiTermination=False,
        SubnetId='subnet-b38e4fcb',
        UserData=open("/var/task/lambdas/provisioner.sh").read(),
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
            'sg-087420ce08a1259b4'
        ],
        InstanceInitiatedShutdownBehavior='terminate',
        IamInstanceProfile={
            'Arn': 'arn:aws:iam::883980837948:instance-profile/web_profile'
        },
        KeyName='general_ssh'
    )

    print(r)

    return
