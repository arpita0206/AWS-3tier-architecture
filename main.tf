#root/main.tf

provider "aws" {
  region = var.AWS_REGION
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
}

module "networking" {
  source     = "../modules/networking"
  name = module.networking.name
  cidr = module.networking.cidr_block

  azs             = ["eu-west-1a", "eu-west-1b"]
#   private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
#   public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

#   enable_nat_gateway = true
#   enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "test"
  }
}

module "compute" {
  source     = "../modules/compute"
#   name = "single-instance"

#   ami                    = "ami-ebd02392"
#   instance_type          = "t2.micro"
#   key_name               = "user1"
#   monitoring             = true
#   vpc_security_group_ids = ["sg-12345678"]
#   subnet_id              = "subnet-eddcdzz4"
  tags = {
    Terraform   = "true"
    Environment = "test"
  }

}

module "database" {
  source     = "../modules/database"
#   identifier = "demodb"

#   engine            = "mysql"
#   engine_version    = "5.7"
#   instance_class    = "db.t3a.large"
#   allocated_storage = 5

#   db_name  = "demodb"
#   username = "user"
#   port     = "3306"

#   iam_database_authentication_enabled = true

#   vpc_security_group_ids = ["sg-12345678"]

#   maintenance_window = "Mon:00:00-Mon:03:00"
#   backup_window      = "03:00-06:00"

#   # Enhanced Monitoring - see example for details on how to create the role
#   # by yourself, in case you don't want to create it automatically
#   monitoring_interval = "30"
#   monitoring_role_name = "MyRDSMonitoringRole"
#   create_monitoring_role = true

  tags = {
    Owner       = "user"
    Environment = "test"
  }

#   # DB subnet group
#   create_db_subnet_group = true
#   subnet_ids             = ["subnet-12345678", "subnet-87654321"]

#   # DB parameter group
#   family = "mysql5.7"

#   # DB option group
#   major_engine_version = "5.7"

#   # Database Deletion Protection
#   deletion_protection = true

#   parameters = [
#     {
#       name = "character_set_client"
#       value = "utf8mb4"
#     },
#     {
#       name = "character_set_server"
#       value = "utf8mb4"
#     }
#   ]

#   options = [
#     {
#       option_name = "MARIADB_AUDIT_PLUGIN"

#       option_settings = [
#         {
#           name  = "SERVER_AUDIT_EVENTS"
#           value = "CONNECT"
#         },
#         {
#           name  = "SERVER_AUDIT_FILE_ROTATIONS"
#           value = "37"
#         },
#       ]
#     },
#   ]

}

module "loadbalancing" {
  source     = "../modules/loadbalancing"

# name = "elb-example"

  public_subnets         = [module.networking.public_subnet_1, module.networking.public_subnet_2]
  vpc_id                  = module.networking.three_tier_vpc
#   security_groups = ["sg-12345678"]
#   internal        = false

#   listener = [
#     {
#       instance_port     = 80
#       instance_protocol = "HTTP"
#       lb_port           = 80
#       lb_protocol       = "HTTP"
#     },
#     {
#       instance_port     = 8080
#       instance_protocol = "http"
#       lb_port           = 8080
#       lb_protocol       = "http"
#       ssl_certificate_id = "arn:aws:acm:eu-west-1:235367859451:certificate/6c270328-2cd5-4b2d-8dfd-ae8d0004ad31"
#     },
#   ]

#   health_check = {
#     target              = "HTTP:80/"
#     interval            = 30
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#     timeout             = 5
#   }

#   access_logs = {
#     bucket = "my-access-logs-bucket"
#   }

#   // ELB attachments
#   number_of_instances = 2
#   instances           = ["i-06ff41a77dfb5349d", "i-4906ff41a77dfb53d"]

  tags = {
    Owner       = "user"
    Environment = "test"
  }

}