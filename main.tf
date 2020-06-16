provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "machine_setup_test_instance" {
  ami           = "ami-09dd2e08d601bff67"
  instance_type = "t2.medium"
  vpc_security_group_ids = [aws_security_group.machine_setup_test_sg.id]
  key_name = aws_key_pair.machine_prov_test_key.key_name

  tags = {
    Name = "machine-prov-test"
  }
}

resource "aws_security_group" "machine_setup_test_sg" {
  name = "machine-prov-test-sg"
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "machine_prov_test_key" {
  key_name   = "machine-prov-test-key"
  public_key = var.public_key
}
