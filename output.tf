output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_id" {
  value = aws_subnet.main.id
}

output "ec2_instance_id" {
  value = aws_instance.main.id
}

output "s3_bucket_name" {
  value = aws_s3_bucket.private_bucket.bucket
}

output "efs_id" {
  value = aws_efs_file_system.main.id
}

output "security_group_id" {
  value = aws_security_group.ssh.id
}
