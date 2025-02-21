provider "aws" {
  region = "us-east-1"
}

resource "aws_ecs_cluster" "flask_app_cluster" {
  name = "flask-app-cluster"
}

resource "aws_ecs_service" "flask_ecs_service" {
  name            = "flask-ecs-service"
  cluster         = aws_ecs_cluster.flask_app_cluster.id
  task_definition = "flask-task-def"  # Ensure this task definition exists
  desired_count   = 1
  launch_type     = "FARGATE"
}

# Output ECS cluster and service details
output "ecs_cluster_name" {
  value = aws_ecs_cluster.flask_app_cluster.name
}

output "ecs_service_name" {
  value = aws_ecs_service.flask_ecs_service.name
}
