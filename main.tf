provider "aws" {
  region = "ap-south-1"  # Replace with your preferred region
}

# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# Subnet
resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1b"  # Replace with your preferred AZ
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

# Route Table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id
}

# Route
resource "aws_route" "main" {
  route_table_id         = aws_route_table.main.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

# Route Table Association
resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

# Security Group for SSH access
resource "aws_security_group" "ssh" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "main" {
  ami           = "ami-05e00961530ae1b55"  
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.main.id
  security_groups = [aws_security_group.ssh.name]

  key_name = "sample-test.pem"  

  user_data = <<-EOF
              #!/bin/bash
              yum install -y amazon-efs-utils
              mkdir -p /data/test
              mount -t efs ${aws_efs_file_system.main.id}:/ /data/test
              echo "${aws_efs_file_system.main.id}:/ /data/test efs defaults,_netdev 0 0" >> /etc/fstab
              EOF

  tags = {
    Name = "Terraform-EC2"
  }
}

# Associate Elastic IP with EC2 Instance
resource "aws_eip_association" "main" {
  instance_id   = aws_instance.main.id
  allocation_id = var.elastic_ip_allocation_id
}

# S3 Bucket
#resource "aws_s3_bucket" "private_bucket" {
 # bucket = var.bucket_name  # Replace with your unique bucket name
  #acl    = "private"
#}


resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.cf_s3_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.cf_s3_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_public_access_block.example,
  ]

  bucket = aws_s3_bucket.cf_s3_bucket.id
  acl    = "public-read"
}


# EFS File System
resource "aws_efs_file_system" "main" {
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = {
    Name = "MyEFS"
  }
}

# EFS Mount Target
resource "aws_efs_mount_target" "main" {
  file_system_id  = aws_efs_file_system.main.id
  subnet_id       = aws_subnet.main.id
  security_groups = [aws_security_group.ssh.id]
}
