terraform {
  cloud {
    organization = "vinsys"

    workspaces {
      project = "Learn Terraform"
      name    = "learn-terraform-aws-get-started"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}


resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = { Name = "custom-vpc" }
}

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-north-1a"
  map_public_ip_on_launch = true

  tags = { Name = "public-subnet-a" }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "eu-north-1b"
  map_public_ip_on_launch = true

  tags = { Name = "public-subnet-b" }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "main-gw" }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "public-rt" }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}


resource "aws_security_group" "ec2" {
  name   = "ec2-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rds" {
  name   = "rds-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_db_subnet_group" "db_subnet" {
  name       = "db-subnet"
  subnet_ids = [aws_subnet.public_a.id, aws_subnet.public_b.id]

  tags = { Name = "DB subnet group" }
}


resource "aws_db_instance" "db" {
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = "admin"
  password               = "Soham123456"
  skip_final_snapshot    = true
  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet.name
  multi_az               = false
}


resource "aws_instance" "app" {
  ami                         = "ami-0d2aad4794ad02001"
  instance_type               = "t3.small"
  subnet_id                   = aws_subnet.public_a.id
  vpc_security_group_ids      = [aws_security_group.ec2.id]
  associate_public_ip_address = true

  user_data = <<EOF
#!/bin/bash
yum update -y
yum install docker -y
systemctl start docker

docker pull sohampawar1030/mysql-project:latest

docker run -d -p 80:3000 \
  -e DB_HOST="${aws_db_instance.db.address}" \
  -e DB_USER="admin" \
  -e DB_PASSWORD="Soham123456" \
  -e DB_NAME="contacts_db" \
  --name contact-app \
  sohampawar1030/mysql-project:latest
EOF
}


output "APP_URL" {
  value = "http://${aws_instance.app.public_ip}"
}

output "DB_ENDPOINT" {
  value = aws_db_instance.db.address
}
