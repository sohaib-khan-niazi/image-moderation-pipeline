import boto3
import json
import os
import uuid
from datetime import datetime
from urllib.parse import unquote_plus

rekognition_client = boto3.client('rekognition')
dynamodb_client = boto3.client('dynamodb')
table_name = os.environ['DYNAMODB_TABLE_NAME']

def lambda_handler(event, context):
    # Get the S3 bucket and object key from the event
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = unquote_plus(event['Records'][0]['s3']['object']['key'])
    
    # Rekognition DetectModerationLabels
    response_moderation = rekognition_client.detect_moderation_labels(
        Image={'S3Object': {'Bucket': bucket, 'Name': key}}
    )
    
    # Rekognition DetectLabels
    response_labels = rekognition_client.detect_labels(
        Image={'S3Object': {'Bucket': bucket, 'Name': key}},
        MaxLabels=10
    )
    
    # Convert results to human-readable arrays
    moderation_labels = [
        f"{label['Name']} ({label['Confidence']:.2f}%)"
        for label in response_moderation.get('ModerationLabels', [])
    ]
    
    tags = [
        f"{label['Name']} ({label['Confidence']:.2f}%)"
        for label in response_labels.get('Labels', [])
    ]
    
    # Store the result in DynamoDB
    item = {
        'image_id': {'S': str(uuid.uuid4())},
        'timestamp': {'S': datetime.utcnow().isoformat()},
        'moderation_labels': {'S': json.dumps(moderation_labels)},
        'tags': {'S': json.dumps(tags)}
    }
    
    # Insert into DynamoDB table
    dynamodb_client.put_item(TableName=table_name, Item=item)
    
    return {
        'statusCode': 200,
        'body': json.dumps('Image processed successfully!')
    }
