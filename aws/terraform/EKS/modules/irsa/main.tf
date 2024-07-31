locals {
  s3_space_permissions = var.include_s3_space_permissions ? [{
    Effect   = "Allow",
    Action   = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:ListBucket",
    ],
    Resource = [
      "arn:aws:s3:::*/*",
      "arn:aws:s3:::*",
    ],
  }] : []

  cassandra_space_permissions = var.include_cassandra_space_permissions ? [{
    Effect   = "Allow",
    Action   = [
      "cassandra:Create",
      "cassandra:CreateMultiRegionResource",
      "cassandra:Drop",
      "cassandra:Alter",
      "cassandra:Select",
      "cassandra:Modify",
    ],
    Resource = "*",
  }] : []

  rds_space_permissions = var.include_rds_space_permissions ? [
    {
      Effect = "Allow",
      Action = [
        "rds-db:connect",
      ],
      Resource = "*",
    },
    {
      Effect = "Allow",
      Action = [
        "rds-data:BatchExecuteStatement",
        "rds-data:BeginTransaction",
        "rds-data:CommitTransaction",
        "rds-data:RollbackTransaction",
      ],
      Resource = "*",
    }
  ] : []

  msk_space_permissions = var.include_msk_space_permissions ? [
    {
      Effect = "Allow",
      Action = [
        "kafka-cluster:Connect",
        "kafka-cluster:CreateTopic",
        "kafka-cluster:DescribeTopic",
        "kafka-cluster:AlterTopic",
        "kafka-cluster:DeleteTopic",
        "kafka-cluster:DescribeTopicDynamicConfiguration",
        "kafka-cluster:AlterTopicDynamicConfiguration",
        "kafka-cluster:ReadData",
        "kafka-cluster:WriteData",
        "kafka-cluster:DescribeGroup",
        "kafka-cluster:AlterGroup",
        "kafka-cluster:DeleteGroup",
        "kafka-cluster:DescribeTransactionalId",
        "kafka-cluster:AlterTransactionalId",
      ],
      Resource = "*",
    }
  ] : []

### DEPLOYER ###
  common_deployer_permissions = var.include_common_deployer_permissions ? [
    {
      Effect = "Allow",
      Action = [
        "ec2:DescribeSubnets",
        "ec2:DescribeVpcs",
        "ec2:CreateSecurityGroup",
        "ec2:DeleteSecurityGroup",
        "ec2:DescribeSecurityGroups",
        "ec2:AuthorizeSecurityGroupIngress"
      ],
      Resource = "*"
    }
  ] : []

  s3_deployer_permissions = var.include_s3_deployer_permissions ? [
    {
      Effect = "Allow",
      Action = [
        "s3:CreateBucket",
        "s3:DeleteBucket",
        "s3:PutObject",
				"s3:GetObject",
				"s3:DeleteObject",
				"s3:ListBucket"
      ],
      Resource = [
        "arn:aws:s3:::*/*",
        "arn:aws:s3:::*",
      ],
    }
  ] : []

  cassandra_deployer_permissions = var.include_cassandra_deployer_permissions ? [ 
    {
      Effect = "Allow"
      Action = [
				"cassandra:Alter",
				"cassandra:Create",
				"cassandra:Drop",
				"cassandra:TagResource",
				"cassandra:UntagResource"        
      ],
      Resource = "*"
    }
  ] : []

  rds_deployer_permissions = var.include_rds_deployer_permissions ? [ 
    {
      Effect = "Allow"
      Action = [
        "rds-db:connect"
      ],
      Resource = "*"
    },
    {
      Effect = "Allow"
      Action = [
				"rds:CreateDBCluster",
				"rds:CreateDBInstance",
				"rds:DeleteDBCluster",
				"rds:DeleteDBInstance",
				"rds:ModifyDBCluster",
				"rds:ModifyDBInstance",
        "rds:StartDBCluster",
				"rds:StartDBInstance",
				"rds:StopDBCluster",
				"rds:StopDBInstance",
				"rds:AddTagsToResource",
				"rds:RemoveTagsFromResource",
        "rds:DescribeDBInstances",
        "rds:CreateDBSubnetGroup",
        "rds:DeleteDBSubnetGroup",
        "rds:DescribeDBSubnetGroups",
        "rds:DescribeDBClusters"
      ],
      Resource = "*"
    }
  ] : []

  msk_deployer_permissions = var.include_msk_deployer_permissions ? [
    {
      Effect = "Allow"
      Action = [
        "kafka-cluster:Connect",
        "kafka-cluster:DescribeCluster",
        "kafka-cluster:AlterCluster",
        "kafka-cluster:DescribeClusterDynamicConfiguration",
        "kafka-cluster:AlterClusterDynamicConfiguration",
        "kafka-cluster:WriteDataIdempotently"
      ],
      Resource = "*"
    }
  ] : []
}

resource "aws_iam_policy" "iam_fabric_space_policy" {
  name        = "${var.cluster_name}_iam_fabric_space_policy"
  description = "Fabric space policy"
  policy      = jsonencode({
    Version   = "2012-10-17",
    Statement = concat(local.s3_space_permissions, local.cassandra_space_permissions, local.rds_space_permissions, local.msk_space_permissions),
  })

  tags = merge(
    {
      Name    = "${var.cluster_name}_iam_fabric_space_policy"
    },
    var.common_tags
  )

}

resource "aws_iam_policy" "iam_deployer_policy" {
  name        = "${var.cluster_name}_iam_deployer_policy"
  description = "Cloud deployer policy"
  policy      = jsonencode({
    Version   = "2012-10-17",
    Statement = concat(local.common_deployer_permissions, local.s3_deployer_permissions, local.cassandra_deployer_permissions, local.rds_deployer_permissions, local.msk_deployer_permissions),
  })

  tags = merge(
    {
      Name    = "${var.cluster_name}_iam_deployer_policy"
    },
    var.common_tags
  )

}

resource "aws_iam_role" "iam_fabric_space_role" {
    name = "${var.cluster_name}_iam_fabric_space_role"
    description = "Fabric space irsa"
    assume_role_policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Principal": {
                    "Service": "ec2.amazonaws.com"
                },
                "Action": "sts:AssumeRole"
            },
            {
                "Effect": "Allow",
                "Principal": {
                    "Federated": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/oidc.eks.${var.aws_region}.amazonaws.com/id/${regex("([^\\/]+$)", data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer)[0]}"
                },
                "Action": "sts:AssumeRoleWithWebIdentity",
                "Condition": {
                    "StringEquals": {
                        "oidc.eks.${var.aws_region}.amazonaws.com/id/${regex("([^\\/]+$)", data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer)[0]}:aud": "sts.amazonaws.com"
                    }
                }
            }
        ]
    })

    tags = merge(
      {
        Name    = "${var.cluster_name}_iam_fabric_space_role"
      },
      var.common_tags
    )
}

resource "aws_iam_role" "iam_deployer_role" {
    name = "${var.cluster_name}_iam_deployer_role"
    description = "Cloud deployer irsa"
    assume_role_policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Principal": {
                    "Service": "ec2.amazonaws.com"
                },
                "Action": "sts:AssumeRole"
            },
            {
                "Effect": "Allow",
                "Principal": {
                    "Federated": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/oidc.eks.${var.aws_region}.amazonaws.com/id/${regex("([^\\/]+$)", data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer)[0]}"
                },
                "Action": "sts:AssumeRoleWithWebIdentity",
                "Condition": {
                    "StringEquals": {
                        "oidc.eks.${var.aws_region}.amazonaws.com/id/${regex("([^\\/]+$)", data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer)[0]}:aud": "sts.amazonaws.com"
                    }
                }
            }
        ]
    })

    tags = merge(
      {
        Name    = "${var.cluster_name}_iam_deployer_role"
      },
      var.common_tags
    )
}

resource "aws_iam_role_policy_attachment" "iam_fabric_space_role_policy_attachment" {
    role       = aws_iam_role.iam_fabric_space_role.name
    policy_arn = aws_iam_policy.iam_fabric_space_policy.arn
}

resource "aws_iam_role_policy_attachment" "iam_deployer_role_policy_attachment" {
    role       = aws_iam_role.iam_deployer_role.name
    policy_arn = aws_iam_policy.iam_deployer_policy.arn
}