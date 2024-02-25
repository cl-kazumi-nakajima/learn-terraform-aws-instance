provider "aws" {
  region = "us-east-2"
}

module "webserver_cluster" {
  # source = "../../../modules/services/webserver-cluster"
  source = "github.com/brikis98/terraform-up-and-running-code//code/terraform/04-terraform-module/module-example/modules/services/webserver-cluster?ref=v0.3.0"

  cluster_name = "webservers-prod"
  db_remote_state_bucket = "terraform-up-and-runnning-state"
  db_remote_state_key = "prod/data-stores/mysql/terraform.tfstate"

  instance_type = "t2.micro"
  min_size = 2
  max_size = 3
}

resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  scheduled_action_name = "scale-out-during-business-hours"
  min_size              = 2
  max_size              = 10
  desired_capacity      = 10
  recurrence            = "0 9 * * *" # デフォルトUTC
  time_zone             = "Asia/Tokyo"

  autoscaling_group_name = module.webserver_cluster.asg_name  # module の output を参照
}

resource "aws_autoscaling_schedule" "scale_in_at_night" {
  scheduled_action_name = "scale-in-at-night"
  min_size              = 2
  max_size              = 10
  desired_capacity      = 2
  recurrence            = "0 17 * * *" # デフォルトUTC
  time_zone             = "Asia/Tokyo"

  autoscaling_group_name = module.webserver_cluster.asg_name  # module の output を参照
}
