variable "aws_region" {
  description = "AWS region"
  default     = "us-west-2a"
}

variable "project_name" {
  description = "Project name"
  default = "Assignment_2"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  default     = "192.168.0.0/16"
}

variable "priv_subnet_cidr" {
  description = "Subnet CIDR"
  default     = "192.168.1.0/24"
}

variable "pub_subnet_cidr" {
  description = "Subnet CIDR"
  default     = "192.168.2.0/24"
}

variable "default_route"{
  description = "Default route"
  default     = "0.0.0.0/0"
}

variable "home_net" {
  description = "Home network"
  default     = "99.199.29.59/32"
}

variable "bcit_net" {
  description = "BCIT network"
  default     = "142.232.0.0/16"
  
}

variable "ami_id" {
  description = "AMI ID"
}

variable "ssh_key_name"{
  description = "AWS SSH key name"
  default = "acit_4640_desktop"
}


resource "aws_vpc" "a02_vpc" {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "a02_vpc"
    Project = var.project_name
  }
}

# A02 Private Subnet
resource "aws_subnet" "a02_priv_subnet" {
  vpc_id            = aws_vpc.a02_vpc.id
  cidr_block = var.priv_subnet_cidr
  # Enabled for Ansible ssh playbook
  map_public_ip_on_launch = true
  availability_zone = "us-west-2a"

  tags = {
    Name = "a02_priv_subnet"
    Project = var.project_name
  }
}

# A02 Public Subnet
resource "aws_subnet" "a02_pub_subnet" {
  vpc_id                  = aws_vpc.a02_vpc.id
  cidr_block = var.pub_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = "us-west-2a"

  tags = {
    Name = "a02_pub_subnet"
    Project = var.project_name
  }
}

# Gateway
resource "aws_internet_gateway" "a02_gw" {
  vpc_id = aws_vpc.a02_vpc.id
  
  tags = {
    Name = "a02_gw"
    Project = var.project_name
  }
}

# Routetable & Association
resource "aws_route_table" "a02_rt" {
  vpc_id = aws_vpc.a02_vpc.id

  route {
    cidr_block = var.default_route
    gateway_id = aws_internet_gateway.a02_gw.id
  }

  tags = {
    Name = "a02_rt"
    Project = var.project_name
  }
}

resource "aws_route_table_association" "a02_rta_pub" {
  subnet_id      = aws_subnet.a02_pub_subnet.id
  route_table_id = aws_route_table.a02_rt.id
}

resource "aws_route_table_association" "a02_rta_priv" {
  subnet_id      = aws_subnet.a02_priv_subnet.id
  route_table_id = aws_route_table.a02_rt.id
}

# Public Security Groups & Rules
resource "aws_security_group" "a02_pub_sg" {
  name        = "a02_pub_sg"
  description = "Public Security Group"
  vpc_id      = aws_vpc.a02_vpc.id
}

resource "aws_vpc_security_group_egress_rule" "egress_pub" {
  security_group_id = aws_security_group.a02_pub_sg.id
  ip_protocol = -1
  cidr_ipv4 = var.default_route
  tags = {
    Name = "egress_rule"
    Project = var.project_name
  }
  
}

resource "aws_vpc_security_group_ingress_rule" "ssh_home" {
  security_group_id = aws_security_group.a02_pub_sg.id
  ip_protocol = "tcp"
  from_port = 22
  to_port = 22
  cidr_ipv4 = var.home_net
  tags = {
    Name = "ssh_home_rule"
    Project = var.project_name
  }
  
}

resource "aws_vpc_security_group_ingress_rule" "ssh_bcit" {
  security_group_id = aws_security_group.a02_pub_sg.id
  ip_protocol = "tcp"
  from_port = 22
  to_port = 22
  cidr_ipv4 = var.bcit_net
  tags = {
    Name = "ssh_bcit_rule"
    Project = var.project_name
  }
  
}

resource "aws_vpc_security_group_ingress_rule" "http_pub" {
  security_group_id = aws_security_group.a02_pub_sg.id
  ip_protocol = "tcp"
  from_port = 80
  to_port = 80
  cidr_ipv4 = var.default_route
  tags = {
    Name = "http_rule"
    Project = var.project_name
  }
  
}

resource "aws_vpc_security_group_ingress_rule" "https_pub" {
  security_group_id = aws_security_group.a02_pub_sg.id 
  ip_protocol = "tcp"
  from_port = 443
  to_port = 443
  cidr_ipv4 = var.default_route
  tags = {
    Name = "https_rule"
    Project = var.project_name
  }
  
}

# Private Secuirty Groups & Rules
resource "aws_security_group" "a02_priv_sg" {
  name        = "a02_priv_sg"
  description = "Private Security Group"
  vpc_id      = aws_vpc.a02_vpc.id
}

resource "aws_vpc_security_group_egress_rule" "egress_priv" {
  security_group_id = aws_security_group.a02_priv_sg.id
  ip_protocol       = -1
  cidr_ipv4         = var.default_route
  tags = {
    Name    = "egress_rule"
    Project = var.project_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh_home_priv" {
  security_group_id = aws_security_group.a02_priv_sg.id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = var.home_net
  tags = {
    Name    = "ssh_home_rule"
    Project = var.project_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh_bcit_priv" {
  security_group_id = aws_security_group.a02_priv_sg.id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = var.bcit_net
  tags = {
    Name    = "ssh_bcit_rule"
    Project = var.project_name
  }
}

# Allow all traffic from Public
resource "aws_security_group_rule" "allow_all_traffic_public" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  source_security_group_id = aws_security_group.a02_pub_sg.id
  security_group_id = aws_security_group.a02_priv_sg.id  
}

# Allow all traffic from Private
resource "aws_security_group_rule" "allow_all_traffic_private" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  source_security_group_id = aws_security_group.a02_priv_sg.id
  security_group_id = aws_security_group.a02_pub_sg.id
}

# Allow traffic between Private
resource "aws_security_group_rule" "allow_traffic_priv_to_priv" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  source_security_group_id = aws_security_group.a02_priv_sg.id
  security_group_id = aws_security_group.a02_priv_sg.id
}



