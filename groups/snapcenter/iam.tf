module "instance_profile" {
  source = "git@github.com:companieshouse/terraform-modules//aws/instance_profile?ref=tags/1.0.283"
  name   = local.common_resource_name

  enable_ssm       = true
  kms_key_refs     = [local.ssm_kms_key_id]
  s3_buckets_write = [local.session_manager_bucket_name]
  s3_buckets_read  = [local.session_manager_bucket_name]

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

resource "aws_iam_policy" "snapcenter" {
  name        = local.common_resource_name
  description = "IAM policy for ${var.service_subtype} EC2 instances"
  policy      = data.aws_iam_policy_document.snapcenter.json
}

resource "aws_iam_role_policy_attachment" "snapcenter" {
  role       = module.instance_profile.aws_iam_role.name
  policy_arn = aws_iam_policy.snapcenter.arn
}

data "aws_iam_policy_document" "snapcenter" {
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

  statement {
    sid    = "SharedServicesResourcesRead"
    effect = "Allow"

    actions = [
      "s3:ListBucket",
      "s3:ListBucketVersions",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetObjectVersionTagging",
      "s3:GetBucketAcl",
      "s3:GetEncryptionConfiguration",
    ]

    resources = [
      "arn:aws:s3:::shared-services.eu-west-2.resources.ch.gov.uk",
      "arn:aws:s3:::shared-services.eu-west-2.resources.ch.gov.uk/*",
    ]
  }

  statement {
    sid       = "GetCallerIdentity"
    effect    = "Allow"
    actions   = ["sts:GetCallerIdentity"]
    resources = ["*"]
  }
}
