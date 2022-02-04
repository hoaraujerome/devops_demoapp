data "aws_iam_policy_document" "ecs_tasks_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# Role that regulates what AWS services the backend task has access
resource "aws_iam_role" "backend_task_role" {
  name               = "${var.project}-${var.environment}-backend-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_assume_role.json

  tags = {
    Name      = "${var.project}-${var.environment}-backend-task-role"
    ManagedBy = "${var.iac_tool}"
  }
}

# Another role is needed, the task execution role. This is due to the fact that the tasks will be 
# executed “serverless” with the Fargate configuration. This means there’s no EC2 instances involved,
# meaning the permissions that usually go to the EC2 instances have to go somewhere else: the Fargate
# service. This enables the service to e.g. pull the image from ECR, spin up or deregister tasks etc.
resource "aws_iam_role" "backend_task_execution_role" {
  name               = "${var.project}-${var.environment}-backend-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_assume_role.json

  tags = {
    Name      = "${var.project}-${var.environment}-backend-task-execution-role"
    ManagedBy = "${var.iac_tool}"
  }
}

resource "aws_iam_role_policy_attachment" "backend_task_execution_role" {
  role       = aws_iam_role.backend_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_security_group" "backend_alb" {
  name        = "${var.project}-${var.environment}-backend-alb-sg"
  description = "Security group for the backend ALB"
  vpc_id      = var.vpc_id

  tags = {
    Name      = "${var.project}-${var.environment}-backend-alb-sg"
    ManagedBy = "${var.iac_tool}"
  }
}

resource "aws_security_group_rule" "everywhere_in_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.backend_alb.id
}

resource "aws_security_group_rule" "instance-listener_out_instance-sg" {
  type                     = "egress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backend_task.id
  security_group_id        = aws_security_group.backend_alb.id
}

resource "aws_security_group" "backend_task" {
  name        = "${var.project}-${var.environment}-backend-task-sg"
  description = "Security group for the backend task"
  vpc_id      = var.vpc_id

  tags = {
    Name      = "${var.project}-${var.environment}-backend-task-sg"
    ManagedBy = "${var.iac_tool}"
  }
}

resource "aws_security_group_rule" "backend-alb_in_instance-listener" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backend_alb.id
  security_group_id        = aws_security_group.backend_task.id
}

resource "aws_security_group_rule" "all_out_everywhere" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.backend_task.id
}

