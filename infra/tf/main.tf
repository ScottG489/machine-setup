provider "aws" {
  region = "us-west-2"
}

module "helpers_spot_instance_ssh" {
  source = "ScottG489/helpers/aws//modules/spot_instance_ssh"
  version = "1.5.0"
  name = random_id.name.hex
  ami = var.ami
  instance_type = var.instance_type
  spot_type = var.spot_type
  spot_price = var.spot_price
  volume_size = var.volume_size
  public_key = var.public_key
  instance_interruption_behavior = "terminate"
}

resource "random_id" "name" {
  byte_length = 4
  prefix = "${var.name}-"
}
