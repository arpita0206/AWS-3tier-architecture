
# Defining Region
variable "AWS_REGION" {
  default = "eu-west-1"
}

variable "AWS_ACCESS_KEY" {
default = "AKIAW4DF572NOCQB52EQ"
}

variable "AWS_SECRET_KEY" {
default = "FqP4F2FnotQxsdhxS6J65xZI8at+Bz14ydxrj8LF"
}

variable "access_ip" {
  type = string
}

variable "db_name" {
  type = string
}

variable "dbuser" {
  type      = string
  sensitive = true
}

variable "dbpassword" {
  type      = string
  sensitive = true
}
