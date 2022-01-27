import json
import boto3
import uuid
import random
from datetime import datetime


def populate(table):
    processors = ["BRAINTREE", "ADYEN", "STRIPE", "PAYPAL", "GOCARDLESS", "INGENICO"]
    currencies = ["GBP", "USD", "EUR"]
    status = [
        "PENDING",
        "FAILED",
        "AUTHORIZED",
        "SETTLING",
        "PARTIALLY_SETTLED",
        "SETTLED",
        "DECLINED",
        "CANCELLED",
    ]
    merchants = ["mercity", "shopulse", "socart", "bransport"]

    for _ in range(20):
        entry = {
            "transaction_id": str(uuid.uuid4()),
            "date": datetime.now().strftime("%m/%d/%Y, %H:%M:%S"),
            "amount": random.randrange(1, 4000),
            "currency": random.choice(currencies),
            "processor": random.choice(processors),
            "merchant": random.choice(merchants),
        }
        response = table.put_item(Item=entry)
    return True


def lambda_handler(event, context):
    client = boto3.resource("dynamodb")
    table = client.Table("playground-transaction-challenge")
    populate(table)
    return {
        "statusCode": 200,
        "body": json.dumps({"message": "transaction table populated"}),
    }
