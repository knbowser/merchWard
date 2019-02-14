provider "aws" {
  region = "us-west-2"
}


resource "aws_iam_role" "merch_ward_role" {
  name = "merch_ward_role"
  assume_role_policy = <<POLICY_END
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY_END
}


resource "aws_lambda_function" "merch_ward" {
  function_name = "merchWard"
  handler = "merchWardApp.lambda_handler"
  runtime = "python3.6"
  filename = "merchWardApp.zip"
  source_code_hash = "${base64sha256(file("merchWardApp.zip"))}"
  role = "${aws_iam_role.merch_ward_role.arn}"
  timeout = 42
  environment {
    variables = {      
      PHONE_NUMBER = "ChangeMe"
      URL = "ChangeMe"
    }
  }
}


resource "aws_cloudwatch_event_rule" "every_hour" {
  name = "every-hour"
  description = "Triggers every hour"
  schedule_expression = "rate(1 hour)"
}


resource "aws_cloudwatch_event_target" "place_a_ward_every_hour" {
  rule = "${aws_cloudwatch_event_rule.every_hour.name}"
  target_id = "merch_ward"
  arn = "${aws_lambda_function.merch_ward.arn}"
}


resource "aws_lambda_permission" "allow_cloudwatch_to_call_merch_ward" {
  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.merch_ward.function_name}"
  principal = "events.amazonaws.com"
  source_arn = "${aws_cloudwatch_event_rule.every_hour.arn}"
}


resource "aws_iam_role_policy" "sns_topic_policy" {
  name = "sns_topic_policy"
  role = "${aws_iam_role.merch_ward_role.id}"
  policy = <<POLICY_END
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sns:Publish"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
POLICY_END
}
