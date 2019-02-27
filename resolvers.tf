/**
 * Points of interest:
 *  - Each resolver has an explicit depends_on for the datasource, this is because the datasource doesn't expose its
 *    name as output so we are forced to reference the datasource_name variable, removing Terraform's ability to infer
 *    a dependency of this resource on the datasource's creation.
 */

data "local_file" "cloudformation_resolver_template" {
  filename = "${path.module}/cloudformation-templates/resolver.json"
}

## List People

data "local_file" "list_people_request_mapping" {
  filename = "${path.module}/people-api/resolvers/listPeople-request-mapping-template.txt"
}

data "local_file" "list_people_response_mapping" {
  filename = "${path.module}/people-api/resolvers/listPeople-response-mapping-template.txt"
}

resource "aws_cloudformation_stack" "list_people_resolver" {
  depends_on = [
    "aws_appsync_datasource.people",
    "aws_cloudformation_stack.api_schema"
  ]
  name = "${var.appsync_name}-list-people-resolver"

  parameters = {
    graphQlApiId = "${aws_appsync_graphql_api.people.id}"
    dataSourceName = "${var.datasource_name}"
    fieldName = "listPeople"
    typeName = "Query"
    requestMappingTemplate = "${data.local_file.list_people_request_mapping.content}"
    responseMappingTemplate = "${data.local_file.list_people_response_mapping.content}"
  }

  template_body = "${data.local_file.cloudformation_resolver_template.content}"
}

# Create Person

data "local_file" "create_source_request_mapping" {
  filename = "${path.module}/people-api/resolvers/createPerson-request-mapping-template.txt"
}

data "local_file" "create_source_response_mapping" {
  filename = "${path.module}/people-api/resolvers/createPerson-response-mapping-template.txt"
}

resource "aws_cloudformation_stack" "create_person_resolver" {
  depends_on = [
    "aws_appsync_datasource.people",
    "aws_cloudformation_stack.api_schema"
  ]
  name = "${var.appsync_name}-create-person-resolver"

  parameters = {
    graphQlApiId = "${aws_appsync_graphql_api.people.id}"
    dataSourceName = "${var.datasource_name}"
    fieldName = "createPerson"
    typeName = "Mutation"
    requestMappingTemplate = "${data.local_file.create_source_request_mapping.content}"
    responseMappingTemplate = "${data.local_file.create_source_response_mapping.content}"
  }

  template_body = "${data.local_file.cloudformation_resolver_template.content}"
}