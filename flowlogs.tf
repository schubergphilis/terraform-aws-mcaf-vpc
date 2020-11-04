data "aws_iam_policy_document" "log_stream_action" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
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

data "aws_iam_policy_document" "log_stream_trust" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"

      identifiers = [
        "vpc-flow-logs.amazonaws.com",
      ]
    }
  }
}

resource "aws_cloudwatch_log_group" "flow_logs" {
  count             = var.flow_logs != null ? 1 : 0
  name              = "vpc-flow-logs-${var.name}"
  retention_in_days = var.flow_logs.retention_in_days
  tags              = {}
}

resource "aws_flow_log" "flow_logs" {
  count           = var.flow_logs != null ? 1 : 0
  iam_role_arn    = aws_iam_role.flow_logs[count.index].arn
  log_destination = aws_cloudwatch_log_group.flow_logs[count.index].arn
  traffic_type    = var.flow_logs.traffic_type
  vpc_id          = aws_vpc.default.id
}

resource "aws_iam_role" "flow_logs" {
  count              = var.flow_logs != null ? 1 : 0
  assume_role_policy = data.aws_iam_policy_document.log_stream_trust.json
  name               = var.flow_logs.iam_role_name
}

resource "aws_iam_role_policy" "flow_logs" {
  count  = var.flow_logs != null ? 1 : 0
  name   = "${var.flow_logs.iam_role_name}-action-policy"
  policy = data.aws_iam_policy_document.log_stream_action.json
  role   = aws_iam_role.flow_logs[count.index].id
}
