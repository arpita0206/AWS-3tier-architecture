# Creating a Variable for ami of type map


variable "ec2_ami" {
  type = map

  default = {
    us-east-1a = "ami-0416962131234133f"
    us-east-1b = "ami-006fce872b320923e"
  }
}

# Creating a Variable for region

variable "region" {
  default = us-east-1a
}


# Creating a Variable for instance_type
variable "instance_type" {    
  type = string
}