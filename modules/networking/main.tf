# --- networking/main.tf ---

### CUSTOM VPC CONFIGURATION
resource "aws_vpc" "three_tier_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "three_tier_vpc"
  }
}
    # Declare the data source
data "aws_availability_zones" "available" {
  state = "available"
}

#-------------------------------------------------------#

# Create internet gateway
resource "aws_internet_gateway" "igw-three-tier" {
  vpc_id = aws_vpc.three_tier_vpc.id
  
  tags = {
    Name        = "igw-three-tier"
  }
}

#-------------------------------------------------------#
# Create 2 public subnets
 resource "aws_subnet" "public_subnet_1" {
  vpc_id     = aws_vpc.three_tier_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id     = aws_vpc.three_tier_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_2"
  }
}

# Create 2 private subnets
resource "aws_subnet" "private_subnet_1" {
  vpc_id     = aws_vpc.three_tier_vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "private_subnet_1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id     = aws_vpc.three_tier_vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "private_subnet_2"
  }
}
#-------------------------------------------------------#
# Create route table and associate to internet gateway
  resource "aws_route_table" "three_tier_route" {
  vpc_id = aws_vpc.three_tier_vpc.id

  route {
    cidr_block = "0.0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-three-tier.id
  }

  tags = {
    Name = "three_tier_route"
  }
}

# Associate public subnets with route table
 resource "aws_route_table_association" "public_route_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.three_tier_route.id
}

resource "aws_route_table_association" "public_route_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.three_tier_route.id
}

# Create security groups

#public SG
resource "aws_security_group" "public_sg" {
  name        = "public_sg"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = aws_vpc.three_tier_vpc.id

  ingress {
    description      = "HTTP traffic"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.three_tier_vpc.cidr_block]
  }

  ingress {
    description      = "SSH traffic"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.three_tier_vpc.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

#private SG
resource "aws_security_group" "private_rds_sg" {
  name        = "private_rds_sg"
  description = "Allow DB and SSH inbound traffic"
  vpc_id      = aws_vpc.three_tier_vpc.id

  ingress {
    description      = "webtier traffic"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.three_tier_vpc.cidr_block]
  }

  ingress {
    description      = "SSH traffic"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.three_tier_vpc.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

#LB SG
resource "aws_security_group" "three_tier_lb_sg" {
  name        = "three_tier_lb_sg"
  description = "Allow Inbound HTTP Traffic"
  vpc_id      = aws_vpc.three_tier_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
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

#EIP and NAT gateway allocation
# resource "aws_nat_gateway" "three_tier_nat" {
#   allocation_id = aws_eip.three_tier_nat.id
#   subnet_id     = aws_subnet.three_tier_nat.id

#   tags = {
#     Name = "gw NAT"
#   }
# }




