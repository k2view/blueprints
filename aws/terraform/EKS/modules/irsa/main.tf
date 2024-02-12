resource "aws_iam_policy" "iam_fabric_space_policy" {
    name        = "${var.cluster_name}_iam_fabric_space_policy"
    description = "Fabric space policy"
    policy      =  <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::*/*",
                "arn:aws:s3:::*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "cassandra:Create",
                "cassandra:CreateMultiRegionResource",
                "cassandra:Drop",
                "cassandra:Alter",
                "cassandra:Select",
                "cassandra:Modify"
            ],
			"Resource": "*"
		}
	]
}
EOF

    tags = {
        Name    = "${var.cluster_name}_iam_fabric_space_policy"
        Env     = var.env
        Owner   = var.owner
        Project = var.project
    }
}

resource "aws_iam_policy" "iam_deployer_policy" {
    name        = "${var.cluster_name}_iam_deployer_policy"
    description = "Cloud deployer policy"
    policy      =  <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Action": "s3:CreateBucket",
			"Resource": "arn:aws:s3:::*"
		},
		{
			"Effect": "Allow",
			"Action": "s3:DeleteBucket",
			"Resource": "arn:aws:s3:::*"
		},
		{
			"Effect": "Allow",
			"Action": [
				"s3:PutObject",
				"s3:GetObject",
				"s3:DeleteObject",
				"s3:ListBucket"
			],
			"Resource": [
				"arn:aws:s3:::*/*",
				"arn:aws:s3:::*"
			]
		},
		{
			"Effect": "Allow",
			"Action": [
				"cassandra:Alter",
				"cassandra:Create",
				"cassandra:Drop",
				"cassandra:TagResource",
				"cassandra:UntagResource"
			],
			"Resource": "*"
		}
	]
}
EOF

    tags = {
        Name    = "${var.cluster_name}_iam_deployer_policy"
        Env     = var.env
        Owner   = var.owner
        Project = var.project
    }
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

    tags = {
        Name    = "${var.cluster_name}_iam_fabric_space_role"
        Env     = var.env
        Owner   = var.owner
        Project = var.project
    }
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

    tags = {
        Name    = "${var.cluster_name}_iam_deployer_role"
        Env     = var.env
        Owner   = var.owner
        Project = var.project
    }
}

resource "aws_iam_role_policy_attachment" "iam_fabric_space_role_policy_attachment" {
    role       = aws_iam_role.iam_fabric_space_role.name
    policy_arn = aws_iam_policy.iam_fabric_space_policy.arn
}

resource "aws_iam_role_policy_attachment" "iam_deployer_role_policy_attachment" {
    role       = aws_iam_role.iam_deployer_role.name
    policy_arn = aws_iam_policy.iam_deployer_policy.arn
}
