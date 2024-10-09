# modules/subnets/main.tf

resource "random_string" "suffix" {
  length = 6
}

resource "aws_subnet" "public" {
  count             = length(var.public_subnets)
  vpc_id            = var.vpc_id
  cidr_block        = var.public_subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "Public Subnet - ${random_string.suffix.result} - ${count.index}"
  }
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  vpc_id            = var.vpc_id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "Private Subnet - - ${random_string.suffix.result} - ${count.index}"
  }
}
