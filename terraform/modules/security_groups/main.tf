locals {
  inbound_ports = [80, 443, 5000]
}

resource "aws_security_group" "lb_sg" {
  vpc_id = var.vpc_id

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic "ingress" {
    for_each = local.inbound_ports
    content {
      from_port = ingress.value
      to_port = ingress.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    
  }
}
# resource "aws_security_group" "prod_sg" {
#   vpc_id = var.vpc_id

#   egress = {
#     from_port = 0
#     to_port = 0
#     protocol = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
  
#   ingress = {
#     from_port = 5000
#     to_port = 5000
#     protocol = "tcp"
#     security_groups = [aws_security_group.lb_sg.id]
#   }
# }