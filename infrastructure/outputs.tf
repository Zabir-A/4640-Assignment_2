output "web_instance_public_dns" {
  description = "Public web EC2 instance DNS"
  value       = aws_instance.web_a02_instance.public_dns
}

output "web_instance_private_dns" {
  description = "Private web EC2 instance DNS"
  value       = aws_instance.web_a02_instance.private_dns
}

output "web_instance_id" {
  description = "Web Instance ID"
  value       = aws_instance.web_a02_instance.id
}


output "backend_instance_private_dns" {
  description = "Private backend EC2 instance DNS"
  value       = aws_instance.backend_a02_instance.private_dns
}


output "backend_instance_public_dns" {
  description = "Public backend EC2 instance DNS"
  value       = aws_instance.backend_a02_instance.public_dns
}

output "backend_instance_id" {
  description = "Backend Instance ID"
  value       = aws_instance.backend_a02_instance.id
}


output "db_instance_private_dns" {
  description = "Private DB EC2 instance DNS"
  value       = aws_instance.db_a02_instance.private_dns
}

output "db_instance_public_dns" {
  description = "Public DB EC2 instance DNS"
  value       = aws_instance.db_a02_instance.public_dns
}

output "db_instance_id" {
  description = "DB Instance ID"
  value       = aws_instance.db_a02_instance.id
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.a02_vpc.id
}

output "public_subnet_id" {
  description = "Public Subnet ID"
  value       = aws_subnet.a02_pub_subnet.id
}

output "private_subnet_id" {
  description = "Private Subnet ID"
  value       = aws_subnet.a02_priv_subnet.id
}

output "public_security_group_id" {
  description = "Public SG ID"
  value       = aws_security_group.a02_pub_sg.id
}

output "private_security_group_id" {
  description = "Private SG ID"
  value       = aws_security_group.a02_priv_sg.id
}
