provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-003634241a8fcdec0"
  instance_type = "t2.large"
  vpc_security_group_ids = [aws_security_group.instance.id]
  key_name = aws_key_pair.machine_prov_test_key.key_name

  tags = {
    Name = "machine-prov-test"
  }
}

resource "aws_security_group" "instance" {
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
