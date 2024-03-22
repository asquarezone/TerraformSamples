resource "aws_security_group" "this" {
  vpc_id = var.vpc_id
  name   = var.name
}

resource "aws_security_group_rule" "ingress" {
  count             = length(var.ingress_rules)
  type              = "ingress"
  from_port         = var.ingress_rules[count.index].from_port
  to_port           = var.ingress_rules[count.index].to_port
  protocol          = var.ingress_rules[count.index].protocol
  cidr_blocks       = var.ingress_rules[count.index].cidr_blocks
  security_group_id = aws_security_group.this.id
  description       = var.ingress_rules[count.index].description
  depends_on        = [aws_security_group.this]
}

resource "aws_security_group_rule" "egress_rules" {
  count             = length(var.egress_rules)
  type              = "egress"
  from_port         = var.egress_rules[count.index].from_port
  to_port           = var.egress_rules[count.index].to_port
  protocol          = var.egress_rules[count.index].protocol
  cidr_blocks       = var.egress_rules[count.index].cidr_blocks
  security_group_id = aws_security_group.this.id
  description       = var.egress_rules[count.index].description
  depends_on        = [aws_security_group.this]
}



