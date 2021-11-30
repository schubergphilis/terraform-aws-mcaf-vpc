data "aws_iam_policy_document" "log_stream_action" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = [
      "*",
    ]
  }
}

module "flow_logs_role" {
  count                 = var.flow_logs != null ? 1 : 0
  source                = "github.com/schubergphilis/terraform-aws-mcaf-role?ref=v0.3.2"
  name                  = var.flow_logs.iam_role_name
  principal_type        = "Service"
  principal_identifiers = ["vpc-flow-logs.amazonaws.com"]
  role_policy           = data.aws_iam_policy_document.log_stream_action.json
  permissions_boundary  = var.flow_logs.iam_role_boundary_policy
  postfix               = var.postfix
  tags                  = var.tags
}

resource "aws_cloudwatch_log_group" "flow_logs" {
  count             = var.flow_logs != null ? 1 : 0
  name              = var.flow_logs.log_group_name != null ? var.flow_logs.log_group_name : "vpc-flow-logs-${var.name}"
  retention_in_days = var.flow_logs.retention_in_days
  tags              = var.tags
}

resource "aws_flow_log" "flow_logs" {
  count           = var.flow_logs != null ? 1 : 0
  iam_role_arn    = module.flow_logs_role[count.index].arn
  log_destination = aws_cloudwatch_log_group.flow_logs[count.index].arn
  traffic_type    = var.flow_logs.traffic_type
  vpc_id          = aws_vpc.default.id
}
