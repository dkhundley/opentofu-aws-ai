import os
import json
import boto3

def lambda_handler(event, context):

    # data = json.loads(event{"body"})

    print('We got it.')
    
    response = {
        "body": json.dumps({"name": "David"}),
        "isBase64Encoded": False,
        "statusCode": 200
    }
    
    return response