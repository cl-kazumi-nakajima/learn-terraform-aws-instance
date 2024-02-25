output "asg_name" {
  value = aws_autoscaling_group.example.name
  description = "The name of the Auto Scaling Group"
}

output "alb_dns_name" {
  value       = aws_lb.example.dns_name
  description = "The domain name of the load balancer"
}

# 追加でルールを設定したいと思った時に、このIDを参照して、aws_security_group_rule を設定する
output "alb_security_group_id" {
  value       = aws_security_group.alb.id
  description = "The ID of the Security Group attached to the load balancer"
}
