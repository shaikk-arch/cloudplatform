resource "aws_ecs_cluster" "cp_py_app_cluster" {
  name = "cp-py-app-cluster"
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_lb" "py_app_cat_gif_lb" {
  name               = "py-app-cat-gif-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups   = [aws_security_group.lb_sg.id]
  subnets            = var.subnets
}

resource "aws_lb_target_group" "py_app_cat_gif_target_group" {
  name     = "py-app-cat-gif-target-group"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"
}

resource "aws_lb_listener" "py_app_cat_gif_lb_listener" {
  load_balancer_arn = aws_lb.py_app_cat_gif_lb.arn
  port              = "80"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.py_app_cat_gif_target_group.arn
  }
}

resource "aws_ecs_task_definition" "py_app_cat_gif_task_definition" {
  family                   = "py-app-cat-gif-task-definition"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "py-app-cat-gif-container"
      image     = "593793029373.dkr.ecr.us-west-1.amazonaws.com/py-app-cat-gif-generator:latest"
      essential = true
      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
          protocol      = "tcp"
        },
      ]
    }
  ])
}

resource "aws_ecs_service" "py_app_cat_gif_service" {
  name            = "py-app-cat-gif-service"
  cluster         = aws_ecs_cluster.cp_py_app_cluster.id
  task_definition = aws_ecs_task_definition.py_app_cat_gif_task_definition.arn
  desired_count   = 1

  launch_type = "FARGATE"
  network_configuration {
    subnets          = var.subnets
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.py_app_cat_gif_target_group.arn
    container_name   = "py-app-cat-gif-container"
    container_port   = 5000
  }

  depends_on = [
    aws_lb_listener.py_app_cat_gif_lb_listener
  ]
}

resource "aws_security_group" "lb_sg" {
  name        = "lb-sg"
  description = "Security group for the Load Balancer"
  vpc_id      = var.vpc_id
}

resource "aws_security_group" "ecs_sg" {
  name        = "ecs-sg"
  description = "Security group for ECS tasks"
  vpc_id      = var.vpc_id
}


