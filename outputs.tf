output "api_key" {
  value = "${aws_appsync_api_key.people_api.key}"
  sensitive = true
}

output "api_uris" {
  value = "${aws_appsync_graphql_api.people.uris}"
}
