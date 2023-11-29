resource "aws_instance" "web_a02_instance" {
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  key_name               = var.ssh_key_name
  subnet_id              = aws_subnet.a02_pub_subnet.id
  vpc_security_group_ids = [aws_security_group.a02_pub_sg.id]
  

  tags = {
    Name = "web_a02_instance"
    Project = var.project_name
    Type = "web"
  }
}

resource "aws_instance" "backend_a02_instance" {
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  key_name               = var.ssh_key_name
  subnet_id              = aws_subnet.a02_priv_subnet.id
  vpc_security_group_ids = [aws_security_group.a02_priv_sg.id]


  tags = {
    Name = "backend_a02_instance"
    Project = var.project_name
    Type = "backend"
  }
}

resource "aws_instance" "db_a02_instance" {
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  key_name               = var.ssh_key_name
  subnet_id              = aws_subnet.a02_priv_subnet.id
  vpc_security_group_ids = [aws_security_group.a02_priv_sg.id]


  tags = {
    Name = "db_a02_instance"
    Project = var.project_name
    Type = "database"
  }
}

resource "local_file" "inventory_file" {

  content = <<EOF
webserver:
  hosts:
    ${aws_instance.web_a02_instance.public_dns}
backend:
  hosts:
    ${aws_instance.backend_a02_instance.public_dns}
database:
  hosts:
    ${aws_instance.db_a02_instance.public_dns}
EOF

  filename = "../service/inventory/inventory.yml"

}

resource "local_file" "group_vars_file" {
  content = <<EOF
web_ec2_public_dns: ${aws_instance.web_a02_instance.public_dns}
backend_ec2_public_dns: ${aws_instance.backend_a02_instance.public_dns}
db_ec2_public_dns: ${aws_instance.db_a02_instance.public_dns}
EOF

  filename = "../service/group_vars/group_variables.yml"

}