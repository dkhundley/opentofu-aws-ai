import os
import json
import boto3
from langchain_core.messages.human import HumanMessage
# from langchain_community.chat_models import BedrockChat

def lambda_handler(event, context):

    print(event['body'])
    
    my_dict = {
        ''
    }
    
    response = {
        "body": json.dumps([{"generated_text": "David"}]),
        "isBase64Encoded": False,
        "statusCode": 200
    }
    
    return response