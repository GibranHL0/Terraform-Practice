variable "access_key" {
  description = "The access key to the AWS account"
  type = string
  sensitive = true
}

variable "secret_key" {
  description = "The secret key to the AWS account"
  type = string
  sensitive = true
}