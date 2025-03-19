data "aws_iam_policy_document" "flow_logs" {
  statement {
    sid    = "VPCFlowLogsPushToCloudWatch"
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:*:*"]
  }
}

module "flow_logs_role" {
  count = var.flow_logs_cloudwatch != null ? 1 : 0

  source  = "schubergphilis/mcaf-role/aws"
  version = "~> 0.5.1"

  name                  = var.flow_logs_cloudwatch.iam_role_name
  name_prefix           = var.flow_logs_cloudwatch.iam_role_name_prefix
  path                  = var.flow_logs_cloudwatch.iam_role_path
  permissions_boundary  = var.flow_logs_cloudwatch.iam_role_permission_boundary
  postfix               = var.flow_logs_cloudwatch.iam_role_postfix
  principal_identifiers = ["vpc-flow-logs.amazonaws.com"]
  principal_type        = "Service"
  role_policy           = data.aws_iam_policy_document.flow_logs.json
  tags                  = var.tags
}

resource "aws_cloudwatch_log_group" "flow_logs" {
  count = var.flow_logs_cloudwatch != null ? 1 : 0

  kms_key_id        = var.flow_logs_cloudwatch.kms_key_arn
  name              = try(var.flow_logs_cloudwatch.log_group_name, "vpc-flow-logs-${var.name}")
  retention_in_days = var.flow_logs_cloudwatch.retention_in_days
  tags              = var.tags
}

resource "aws_flow_log" "flow_logs" {
  count = var.flow_logs_cloudwatch != null ? 1 : 0

  iam_role_arn             = module.flow_logs_role[count.index].arn
  log_destination          = aws_cloudwatch_log_group.flow_logs[count.index].arn
  log_destination_type     = "cloud-watch-logs"
  log_format               = var.flow_logs_cloudwatch.log_format
  max_aggregation_interval = var.flow_logs_cloudwatch.max_aggregation_interval
  tags                     = var.tags
  traffic_type             = var.flow_logs_cloudwatch.traffic_type
  vpc_id                   = aws_vpc.default.id
}
