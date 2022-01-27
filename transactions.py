from chalice import Chalice
import boto3
from boto3.dynamodb.conditions import Key

app = Chalice(app_name="transactions")

## Init client
client = boto3.resource("dynamodb")
table = client.Table("playground-transaction-challenge")

@app.route('/transactions', methods=['GET'])
def transactions():
  request = app.current_request
  if request.query_params == None:
    return table.scan(AttributesToGet=['transaction_id'])
  else:
    merchant_name = request.query_params.get('merchant')
    scanResult = table.scan(
                  FilterExpression=Key('merchant').eq(merchant_name)
                )
    return scanResult

@app.route('/transactions/{transaction_id}', methods=['GET'])
def single_transaction(transaction_id):
    scanResult = table.scan(
                  FilterExpression=Key('transaction_id').eq(transaction_id)
                )
    return scanResult
