provider "aws" {
  region = "ap-south-1"
}

resource "aws_ecs_cluster" "demo_ecs_cluster" {
  name = "ecs-cluster-dev"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "demo_task_definition" {
  family                   = "demo-ecs-task-definition-dev"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = "2048"
  cpu                      = "1024"

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name  = "demo-ecs-container-dev"
      image = "vanapagan/test-rest-api:latest"
      environment = [
        {
          name  = "TEST_ENV",
          value = "dev"
        }
      ]
      essential = true
      healthCheck = {
        command  = ["CMD-SHELL", "curl -f http://localhost:8080/about || exit 1"]
        interval = 10
        retries  = 3
        timeout  = 5
      }
      portMappings = [
        {
          name          = "http"
          protocol      = "tcp"
          containerPort = 8080
          hostPort      = 8080
        }
      ]
      memory = 256
      cpu    = 256
    }
  ])
}

resource "aws_ecs_service" "demo_ecs_service" {
    name            = "demo-ecs-service-dev"
    cluster         = aws_ecs_cluster.demo_ecs_cluster.id
    task_definition = aws_ecs_task_definition.demo_task_definition.arn
    desired_count   = 3
    launch_type     = "FARGATE"
    network_configuration {
      subnets          = ["subnet-0a0b0c0d0e0f0g0h"]
      security_groups  = ["sg-0a0b0c0d0e0f0g0h"]
      assign_public_ip = true
    }
}
