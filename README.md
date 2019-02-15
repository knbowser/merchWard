# Merch Ward
Merch Ward is a serverless web scraper built on AWS Lambda triggered by AWS Cloudwatch Events. It checks Riot Games merch store for item availability, and sends text message notification via AWS SNS if the item is in stock. Infrastructure as code using Terraform. 


## Dev Guide

### Getting Started


Before beginning you will need:
1. Valid AWS credentials 
	* https://aws.amazon.com/console/
2. Terraform
	* https://www.terraform.io/
3. An activated Python virtual environment
	* https://docs.python.org/3/tutorial/venv.html
		* `python3 -m venv /tmp/foo`
		* `source /tmp/foo/bin/activate`

Instructions:
1. `git clone https://github.com/knbowser/merchWard.git`
3. Set `PHONE_NUMBER` and `URL` in `deploy/main.tf`
   * `PHONE_NUMBER` should be in format `+12223334444`
   * `URL` should be a link to the Riot merch store
     * i.e. https://na.merch.riotgames.com/en/clothing/hoodies/star-guardian-varsity-jacket-unisex.html
4. `cd ../merchWardApp/deploy`
5. `make deploy`

