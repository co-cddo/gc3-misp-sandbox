module "fargate" {
  source  = "atrakic/fargate/aws"
  version = "0.18.0"  

  name = "demo" # String, Required: this name will be used for many components of your infrastructure (vpc, loadbalancer, ecs cluster, etc...)

  vpc_create = true # Boolean, Optional: variable that tells the module whether or not to create its own VPC. default = true
  vpc_external_id = "vpc-xxxxxxx" # String, Optional: tells the module to use an already create vpc to ingrate with the ecs cluster. vpc_create MUST be false otherwise this value is ignored

  vpc_cidr = "10.0.0.0/16" # String, Optional: the vpc's CIDR to be used when vpc_create is true. default = "10.0.0.0/16"

  vpc_public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"] # List[String], Optional: public subnets' CIDRs. default = [10.0.1.0/24, 10.0.2.0/24, 10.0.3.0/24].
  vpc_private_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"] # List[String], Optional: private subnets' CIDRs. default = [10.0.101.0/24, 10.0.102.0/24, 10.0.103.0/24].

  vpc_external_public_subnets_ids = ["subnet-xxxxxx"] # List[String], Optional: lists of ids of external public subnets. var.vpc_create must be false, otherwise, this variable will be ignored.
  vpc_external_private_subnets_ids = ["subnet-xxxxxx"] # List[String], Optional: lists of ids of external private subnets. var.vpc_create must be false, otherwise, this variable will be ignored.

  codepipeline_events_enabled = true # Boolean, Optional: sns topic that exposes codepipeline events such as STARTED, FAILED, SUCCEEDED, CANCELED for new deployments. default = false.

  ssm_allowed_parameters = "backend_*" # String, Optional: SSM parameter prefix. Allows the tasks to pull and use SSM parameters during task bootstrap. In case of requiring parameters from a different region, specify the full ARN string.

  services = { # Map, Required: the main object containing all information regarding fargate services
    name_of_your_service = { # Map, Required at least one: object containing specs of a specific Fargate service.
      task_definition = "api.json" # String, Required: string matching a valid ECS Task definition json file. This is a relative path ⚠️.
      container_port  = 3000 # Number, Required: tcp port that the tasks will be listening to.
      cpu             = "256" # String, Required: CPU units used by the tasks
      memory          = "512" # String, Required: memory used by the tasks
      replicas        = 5 # Number, Required: amount of task replicas needed for the ecs service

      registry_retention_count = 15 # Number, Optional: sets how many images does the ecr registry will retain before recycling old ones. default = 20
      logs_retention_days      = 14 # Number, Optional: sets how many days does the cloud watch log group will retain logs entries before deleting old ones. default = 30

      health_check_interval = 100 # Number, Optional: sets the interval in seconds for the health check operation. default = 30
      health_check_path     = "/healthz" # String, Optional: sets the path that the tasks are exposing to perform health checks. default = "/"

      task_role_arn = "arn:...." # String(valid ARN), Optional: sets a IAM role to the running ecs task.

      acm_certificate_arn = "arn:...." # String(valid ARN), Optional: turns on the HTTPS listener on the ALB. This certificate should be an already allocated in ACM.

      auto_scaling_max_replicas = 5 # Number, Optional: sets the max replicas that this service can scale up. default = same as replicas
      auto_scaling_max_cpu_util = 60 # Number, Optional: the avg CPU utilization needed to trigger a auto scaling operation

      allow_connections_from = ["api2"] # List[String], Optional: By default all services can only accept connections from their ALB. To explicitly allow connections from one service to another, use this label. This means that THIS service can be reached by service `api2`

      service_discovery_enabled = true # Boolean, Optional: enables service discovery by creating a private Route53 zone. ...local
    }

    another_service = {
      ...
    }
  }
}
