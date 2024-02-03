import requests
import json

url = "https://6a4lya853h.execute-api.us-east-1.amazonaws.com/TEST/inference/"
headers = {"Content-Type": "application/json"}

with open('../sample_json/test.json', 'r') as f:
    data = json.load(f)

responses = requests.post(
    url = url,
    data = json.dumps(data),
    headers = headers,
    verify = False
)

print(responses)