provider "aws" {
  region = "us-west-2"
}

module "spot_instance_ssh" {
  source = "./modules/spot_instance_ssh"
  name = random_id.name.hex
  public_key = var.public_key
}

resource "random_id" "name" {
  byte_length = 4
  prefix = "${var.name}-"
}
