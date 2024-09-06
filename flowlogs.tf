data "aws_iam_policy_document" "log_stream_action" {
  # checkov:skip=CKV_AWS_111: Policy needs to be locked down
  # checkov:skip=CKV_AWS_356: Policy needs to be locked down
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
  count = var.flow_logs != null ? 1 : 0

  source  = "schubergphilis/mcaf-role/aws"
  version = "~> 0.4.0"

  name                  = var.flow_logs.iam_role_name
  principal_type        = "Service"
  principal_identifiers = ["vpc-flow-logs.amazonaws.com"]
  role_policy           = data.aws_iam_policy_document.log_stream_action.json
  permissions_boundary  = var.flow_logs.iam_role_permission_boundary
  postfix               = var.postfix
  tags                  = var.tags
}

resource "aws_cloudwatch_log_group" "flow_logs" {
  # checkov:skip=CKV_AWS_158: KMS Support needs to be added
  count             = var.flow_logs != null ? 1 : 0
  name              = var.flow_logs.log_group_name != null ? var.flow_logs.log_group_name : "vpc-flow-logs-${var.name}"
  retention_in_days = var.flow_logs.retention_in_days
  tags              = var.tags
}

resource "aws_flow_log" "flow_logs" {
  count                = var.flow_logs != null ? 1 : 0
  iam_role_arn         = module.flow_logs_role[count.index].arn
  log_destination      = aws_cloudwatch_log_group.flow_logs[count.index].arn
  log_destination_type = "cloud-watch-logs"
  log_format           = var.flow_logs.log_format
  traffic_type         = var.flow_logs.traffic_type
  vpc_id               = aws_vpc.default.id
  tags                 = var.tags
}
