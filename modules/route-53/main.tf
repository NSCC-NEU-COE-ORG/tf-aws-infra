resource "aws_route53_zone" "main" {
  name = "chakradharabhinay.me"
}


resource "aws_route53_record" "dev" {
  zone_id = aws_route53_zone.main.zone_id
  name     = "dev.chakradharabhinay.me"
  type     = "A"
  ttl      = 300
  records  = [var.instance_public_ip]
}

resource "aws_route53_record" "demo" {
  zone_id = aws_route53_zone.main.zone_id
  name     = "demo.chakradharabhinay.me"
  type     = "A"
  ttl      = 300
  records  = [var.instance_public_ip]
}