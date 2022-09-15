locals {
  ec2_platform_config = <<-END
      #cloud-config
      ${jsonencode({
  write_files = [
    {
      path        = "./home/ubuntu/ec2_main_stream.py" # specify the path (including the file name) in ec2
      permissions = "0644"
      owner       = "root:root"
      encoding    = "b64"
      content     = filebase64(" ") #specify the path (including the file name) from where to transfer to ec2
    },
    {
      path        = "./home/ubuntu/refinitiv-data.config.json"
      permissions = "0644"
      owner       = "root:root"
      encoding    = "b64"
      content     = filebase64(" ")
    },
  ]
})}
    END
}

resource "aws_security_group" "ec2_group" {
  name = "ec2_group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}


resource "aws_instance" "my_ec2_server" {
  ami             = " " #provide the ID of your image
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.ec2_group.name]
  key_name        = "for-news"
  user_data       = local.ec2_platform_config
  tags = {
    Name = var.instance_name
  }
}
