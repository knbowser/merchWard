import boto3
import requests
import bs4
import os
import re

phone_number = os.environ.get("PHONE_NUMBER")
url = os.environ.get("URL")

# When updating use this inside merchWardApp directory
# 1. zip -r --exclude=*v-env* --exclude=*.zip merchWardApp.zip *
# 2. aws lambda update-function-code --function-name merchWard --zip-file fileb://merch_ward.zip

def lambda_handler(event, context):
    # Getting the webpage, creating a Response object
    response = requests.get(url)

    soup =  bs4.BeautifulSoup(response.text, "html.parser")

    sent_message = False
    test = False #for testing purposes
    
    # If "back soon" isn't found send notification
    if (not soup.find_all(string=re.compile("Be back soon"))) and (not soup.find_all(string=re.compile("Retired"))):
        client = boto3.client("sns")
        client.publish(PhoneNumber=phone_number, Message=("The merch you wanted is available at "+url))
        sent_message = True

    if (test==True):
        client = boto3.client("sns")
        client.publish(PhoneNumber=phone_number, Message="test message")
        sent_message = True
        

    return {'sent_message': sent_message}
