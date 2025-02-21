provider "aws" {
  region = "us-east-1"
}

# Output ECS cluster and service details
output "ecs_cluster_name" {
  value = aws_ecs_cluster.flask_app_cluster.name
}

output "ecs_service_name" {
  value = aws_ecs_service.flask_ecs_service.name
}
