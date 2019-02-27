variable "aws_region" {
  default = "us-east-1"
  description = "Region to create the AppSync resources under"
}

variable "appsync_name" {
  default = "demo-people-api"
  description = "Name of the AppSync instance, and also used to prefix resources"
}

variable "datasource_name" {
  default = "demonstration_people_table"
  description = "Name of the data source to be created"
}
