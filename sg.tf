# Security groups to access database1.apse2
resource "aws_security_group" "sg" {
  name        = "status.fediservices.nz"
  description = "status.fediservices.nz"

  vpc_id = aws_vpc.vpc.id
}

# Allow out
resource "aws_security_group_rule" "allow_egress" {
  security_group_id = aws_security_group.sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}

# Allow HTTP traffic
resource "aws_security_group_rule" "http" {
  security_group_id = aws_security_group.sg.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}

# Allow HTTPS traffic
resource "aws_security_group_rule" "https" {
  security_group_id = aws_security_group.sg.id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}
