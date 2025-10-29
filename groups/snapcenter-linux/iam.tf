module "instance_profile" {
  source = "git@github.com:companieshouse/terraform-modules//aws/instance_profile?ref=tags/1.0.283"
  name   = local.common_resource_name

  enable_ssm   = true
  kms_key_refs = concat(
    [local.ssm_kms_key_id],
    local.s3_resources_kms_key_arn != "" ? [local.s3_resources_kms_key_arn] : []
  )
  s3_buckets_write = [local.session_manager_bucket_name]
  s3_buckets_read  = [
    local.session_manager_bucket_name,
    local.s3_resources_bucket_name
  ]

  custom_statements = [
    {
      sid       = "CloudWatchMetricsWrite"
      effect    = "Allow"
      resources = ["*"]
      actions = [
        "cloudwatch:PutMetricData"
      ]
    },
    {
      sid       = "AllowDescribeTags"
      effect    = "Allow"
      resources = ["*"]
      actions = [
        "ec2:DescribeTags",
        "ec2:DescribeInstances"
      ]
    }
  ]
}

resource "aws_iam_role_policy_attachment" "ssm_session_manager" {
  role       = module.instance_profile.aws_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_policy" "snapcenter_linux" {
  name        = local.common_resource_name
  description = "IAM policy for ${var.service_subtype} EC2 instances"
  policy      = data.aws_iam_policy_document.snapcenter_linux.json
}

resource "aws_iam_role_policy_attachment" "snapcenter_linux" {
  role       = module.instance_profile.aws_iam_role.name
  policy_arn = aws_iam_policy.snapcenter_linux.arn
}

data "aws_iam_policy_document" "snapcenter_linux" {
  statement {
    sid    = "SnapCenterEC2Permissions"
    effect = "Allow"

    actions = [
      "ec2:CreateSnapshot",
      "ec2:CreateSnapshots",
      "ec2:DeleteSnapshot",
      "ec2:DescribeSnapshots",
      "ec2:DescribeVolumes",
      "ec2:DescribeInstances",
      "ec2:CreateTags",
      "ec2:DescribeTags"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "SnapCenterEBSPermissions"
    effect = "Allow"

    actions = [
      "ebs:ListSnapshotBlocks",
      "ebs:GetSnapshotBlock",
      "ebs:PutSnapshotBlock",
      "ebs:StartSnapshot",
      "ebs:CompleteSnapshot"
    ]

    resources = ["*"]
  }
}
