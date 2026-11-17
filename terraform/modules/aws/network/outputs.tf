output "security_group_id" {
  description = "ID of the security group, which has no inbound rules."
  value       = aws_security_group.this.id
}
