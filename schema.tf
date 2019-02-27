data "local_file" "cloudformation_schema_template" {
  filename = "${path.module}/cloudformation-templates/schema.json"
}

data "local_file" "schema" {
  filename = "${path.module}/people-api/schema.graphql"
}

resource "aws_cloudformation_stack" "api_schema" {
  depends_on = ["aws_appsync_datasource.people"]
  name = "${var.appsync_name}-schema"

  parameters = {
    graphQlApiId = "${aws_appsync_graphql_api.people.id}"
    graphQlSchema = "${data.local_file.schema.content}"
  }

  template_body = "${data.local_file.cloudformation_schema_template.content}"
}