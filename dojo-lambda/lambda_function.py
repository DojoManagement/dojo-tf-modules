import json


def lambda_handler(event, context):
    print("Hello Test")

    return {
        "statusCode": 200,
        "body": json.dumps("Hello Test")
    }
