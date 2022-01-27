USER := gertjan
ENVIRONMENT := playground
REGION := eu-west-1

functions:
	zip -r functions/transactions.zip transactions.py
	zip -r functions/populate.zip populate.py

.PHONY: functions init plan apply