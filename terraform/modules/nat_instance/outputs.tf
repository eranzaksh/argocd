# Output for instance ID
output "nat-instance_id" {
  value = aws_instance.ec2_instance.id
}

output "nat_instance_network_interface_id" {
  value = aws_instance.ec2_instance.primary_network_interface_id  # Correct attribute
}