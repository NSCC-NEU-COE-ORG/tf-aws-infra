resource "aws_route53_zone" "main" {
  name = "chakradharabhinay.me"
}


resource "aws_route53_record" "dev" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "dev.chakradharabhinay.me"
  type    = "A"
  alias {
    name                   = var.lb_dns_name
    zone_id                = var.lb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "demo" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "demo.chakradharabhinay.me"
  type    = "A"
  alias {
    name                   = var.lb_dns_name
    zone_id                = var.lb_zone_id
    evaluate_target_health = true
  }
}