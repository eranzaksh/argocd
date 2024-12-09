variable "ami_id" {
  description = "The AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "The EC2 instance type (e.g., t2.micro)"
  type        = string
}

variable "key_name" {
  description = "Key pair name to allow SSH access"
  type        = string
}

variable "subnet_id" {
  description = "The subnet ID where the EC2 instance will be created"
  type        = string
}

variable "security_groups" {
  description = "List of security groups to associate with the EC2 instance"
  type        = list(string)
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "nat-instance"
}