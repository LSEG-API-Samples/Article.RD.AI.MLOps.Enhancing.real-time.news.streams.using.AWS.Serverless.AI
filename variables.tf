variable "instance_name" {
  description = "EC2 name tag"
  type        = string
  default     = "TerraformMicroInstance"
}

variable "aws_project_path" {
  type    = string
  default = "/Users/haykaz_aramyan/Library/CloudStorage/OneDrive-LondonStockExchangeGroup/Projects/Sentiment-AWS/"
}


variable "rabbitmq_user" {
  description = "The username for the RabbitMQ user"
  type        = string
}

variable "rabbitmq_password" {
  description = "The password for the RabbitMQ user"
  type        = string
}

variable "access_key" {
  description = "AWS access_key"
  type        = string
}

variable "secret_key" {
  description = "AWS secret key"
  type        = string
}


