resource "aws_instance" "my-machine" {
  # Creates four identical aws ec2 instances
  count = 2     
  
  # All four instances will have the same ami and instance_type
  ami = lookup(var.ec2_ami,var.region) 
  instance_type = var.instance_type # 
  tags = {
    # The count.index allows you to launch a resource 
    # starting with the distinct index number 0 and corresponding to this instance.
    Name = "my-machine-${count.index}"
  }
}

#ASG
resource "aws_launch_template" "terraform_asg" {
  name_prefix   = "terraform_asg"
  image_id      = "ami-1a2b3c"
  instance_type = "t2.micro"
}

resource "aws_autoscaling_group" "terraform_asg_gp" {
  availability_zones = ["eu-east-1a"]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1

  launch_template {
    id      = aws_launch_template.terraform_asg.id
    version = "$Latest"
  }
}