variable "region" {
  description = "The AWS region to create resources in."
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "The CIDR block for the subnet."
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "The availability zone to launch resources in."
  default     = "ap-south-1b"
}

variable "instance_type" {
  description = "The instance type for the EC2 instance."
  default     = "t2.micro"
}

variable "ami" {
  description = "The AMI ID for the EC2 instance."
  default     = "ami-05e00961530ae1b55"  
}

variable "key_name" {
  description = "The name of the SSH key pair."
  default     = "sample-test.pem"  
}

variable "bucket_name" {
  description = "The name of the S3 bucket."
  default     = "my-private-test-bucket"  
}

variable "elastic_ip_allocation_id" {
  description = "The allocation ID of the pre-existing Elastic IP."
  default     = "eipalloc-0033844fa79b894c9"  # Replace with your Elastic IP allocation ID
}
