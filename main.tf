provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_dynamodb_table" "people" {
  name           = "${var.datasource_name}"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_appsync_graphql_api" "people" {
  name                = "${var.appsync_name}"
  authentication_type = "API_KEY"
}

resource "aws_appsync_api_key" "people_api" {
  api_id  = "${aws_appsync_graphql_api.people.id}"
}

resource "aws_iam_role" "api" {
  name = "${var.appsync_name}-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "appsync.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "api_to_dynamodb_policy" {
  name = "${var.appsync_name}_api_dynamodb_policy"
  role = "${aws_iam_role.api.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "dynamodb:PutItem",
        "dynamodb:Scan"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_dynamodb_table.people.arn}"
      ]
    }
  ]
}
EOF
}

resource "aws_appsync_datasource" "people" {
  api_id           = "${aws_appsync_graphql_api.people.id}"
  name             = "${var.datasource_name}"
  service_role_arn = "${aws_iam_role.api.arn}"
  type             = "AMAZON_DYNAMODB"

  dynamodb_config {
    table_name = "${aws_dynamodb_table.people.name}"
  }
}
