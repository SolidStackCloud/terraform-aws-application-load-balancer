resource "aws_security_group" "main" {
  name        = "${var.project_name}-load-balance"
  description = "Configurado para parmitir trafego inbound e outbound"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-load-balancer"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  for_each          = { for i, j in var.ingress_rules_ipv4 : i => j }
  security_group_id = aws_security_group.main.id
  cidr_ipv4         = each.value.cidr_ipv4
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  ip_protocol       = each.value.ip_protocol

  description = try(each.value.description, null)
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv6" {
  for_each          = { for i, j in var.ingress_rules_ipv6 : i => j }
  security_group_id = aws_security_group.main.id
  cidr_ipv6         = each.value.cidr_ipv6
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  ip_protocol       = each.value.ip_protocol

  description = try(each.value.description, null)
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.main.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.main.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1"
}