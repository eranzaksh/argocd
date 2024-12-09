variable "user_data" {
  description = "User data to be applied to the instance"
  type        = string
  default     = ""
}

resource "aws_instance" "ec2_instance" {
  ami                    = var.ami_id
  instance_type         = var.instance_type
  key_name              = var.key_name
  subnet_id             = var.subnet_id
  vpc_security_group_ids = var.security_groups

  # Disable source/destination checking
  source_dest_check = false
  
  # Add your user data script here
  user_data = <<-EOF
    #!/bin/bash
    # Install updates
    sudo yum install iptables-services -y
    sudo systemctl enable iptables
    sudo systemctl start iptables

    echo "net.ipv4.ip_forward=1" | sudo tee /etc/sysctl.d/custom-ip-forwarding.conf > /dev/null

    sudo sysctl -p /etc/sysctl.d/custom-ip-forwarding.conf

    # get the netstat value
    iface=$(netstat -i | awk 'NR>2 {print $1}' | grep -E '^(eth|en)' | head -n 1)

    sudo /sbin/iptables -t nat -A POSTROUTING -o $iface -j MASQUERADE
    sudo /sbin/iptables -F FORWARD
    sudo service iptables save
    # Any other startup commands you want to run
  EOF

  tags = {
    Name = var.instance_name
  }
}



