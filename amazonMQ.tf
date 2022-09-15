resource "aws_mq_broker" "rabbitMQ" {
  broker_name         = "myService"
  publicly_accessible = true

  engine_type        = "RabbitMQ"
  engine_version     = "3.9.16"
  host_instance_type = "mq.t3.micro"

  user {
    username = var.rabbitmq_user
    password = var.rabbitmq_password
  }
}
