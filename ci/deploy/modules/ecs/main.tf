resource "aws_cloudwatch_log_group" "backend" {
  name = "/ecs/${var.project}-${var.environment}-backend-task"

  tags = {
    Name      = "${var.project}-${var.environment}-backend-container-logs"
    ManagedBy = "${var.iac_tool}"
  }
}

resource "aws_ecs_task_definition" "backend" {
  family                   = "${var.project}-${var.environment}-backend-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.backend_task_execution_role.arn
  task_role_arn            = aws_iam_role.backend_task_role.arn

  container_definitions = jsonencode([{
    name      = "${var.project}-${var.environment}-backend-container"
    image     = "${var.aws_ecr_backend_repository_url}:latest"
    essential = true
    portMappings = [{
      protocol      = "tcp"
      containerPort = 8080
      hostPort      = 8080
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.backend.name
        awslogs-stream-prefix = "ecs"
        awslogs-region        = var.region
      }
    }
  }])

  tags = {
    Name      = "${var.project}-${var.environment}-backend-task"
    ManagedBy = "${var.iac_tool}"
  }
}

resource "aws_ecs_cluster" "backend" {
  name = "${var.project}-${var.environment}-backend-cluster"

  tags = {
    Name      = "${var.project}-${var.environment}-backend-cluster"
    ManagedBy = "${var.iac_tool}"
  }
}

resource "aws_ecs_service" "backend" {
  name                               = "${var.project}-${var.environment}-backend-service"
  cluster                            = aws_ecs_cluster.backend.id
  task_definition                    = aws_ecs_task_definition.backend.arn
  desired_count                      = 1
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  health_check_grace_period_seconds  = 60
  force_new_deployment               = true

  network_configuration {
    subnets          = var.private_subnet_ids
    assign_public_ip = false
    security_groups  = [aws_security_group.backend_task.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.backend.arn
    container_name   = "${var.project}-${var.environment}-backend-container"
    container_port   = 8080
  }

  # we ignore task_definition changes as the revision changes on deploy of a new version of the application
  # desired_count is ignored as it can change due to autoscaling policy
  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
}

