# --- compute/outputs.tf ---

output "terraform_asg_outpt" {
  value = aws_autoscaling_group.terraform_asg_gp
}