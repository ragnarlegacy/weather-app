provider "aws" {
  region = "us-east-1"
}

resource "aws_ecr_repository" "weather_app" {
  name = "weather-app"
}

resource "aws_ecs_cluster" "weather_app" {
  name = "weather-app-cluster"
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  ]
}

resource "aws_ecs_task_definition" "weather_app" {
  family                   = "weather-app-task"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = file("${path.module}/ecs-task-definition.json")
}

resource "aws_ecs_service" "weather_app" {
  name            = "weather-app-service"
  cluster         = aws_ecs_cluster.weather_app.id
  task_definition = aws_ecs_task_definition.weather_app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = ["subnet-12345678"]  # Replace with your subnet IDs
    security_groups = ["sg-12345678"]     # Replace with your security group ID
  }
}
