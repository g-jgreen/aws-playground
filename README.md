# AWS Playground

Quick setup of a few services and lambdas on AWS

## Contains: 
- functions
  - populate.py
  - transactions.py
- layers
  - chalice.zip (default layer)
- terraform
  - modules
    - apigateway
    - dynamodb
    - lambda
    - s3
    - s3_object
  - playground
    - main.tf

## How to use

Requirements:
- AWS access
  - AWS Access Key ID
  - AWS Access Key Secret
- AWS CLI (`brew install awscli`)
- Terraform v0.14.11

Configure AWS 
> RUN `aws configure `

### Make functions

> RUN `primer make functions`

```
Example

  ➜  primer make functions
  zip -r functions/transactions.zip transactions.py
  updating: transactions.py (deflated 59%)
  zip -r functions/populate.zip populate.py
  updating: populate.py (deflated 51%)
```

### Make layers

```
Example

  mkdir -p chalice/python
  pip3 install chalice -t chalice/python
  cd chalice 
  zip -r chalice.zip python
```

Once done, move the zip to the layers directory. 

### Run terraform

Go to `/terraform/playground` and run: 

```
Init
  terraform init

Plan
  terraform plan -var username="gertjan" -var environment="playground" -var aws_region="eu-west-1" 

Apply
  terraform apply -var username="gertjan" -var environment="playground" -var aws_region="eu-west-1" 

Destroy
  terraform destroy -var username="gertjan" -var environment="playground" -var aws_region="eu-west-1" 
```

### Test the API: 

Populate the table with some data using:

`curl -X POST APIGW_URL/populate`

List transactions:

`curl -X GET APIGW_URL/transactions`

Filter transactions by merchant:

`curl -X GET APIGW_URL/transactions?merchant=merchant_name`

Get a transaction:

`curl -X GET APIGW_URL/transactions/<transaction_id>`

> Logs can be found on AWS Cloudwatch
