resource "aws_iam_policy" "iam_deployer_policy" {
    name        = "${var.cluster_name}_iam_deployer_policy"
    description = "Cloud deployer irsa policy"
    policy      = file("${path.module}/iam_deployer_policy.json")
    
    tags = {
        Name    = "${var.cluster_name}_iam_deployer_policy"
        Env     = var.env
        Owner   = var.owner
        Project = var.project
    }
}

resource "aws_iam_role" "iam_deployer_role" {
    name = "iam_deployer_role"
    description = "Cloud deployer irsa"
    assume_role_policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Principal": {
                    "Federated": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/oidc.eks.${var.aws_region}.amazonaws.com/id/${regex("([^\\/]+$)", data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer)[0]}"
                },
                "Action": "sts:AssumeRoleWithWebIdentity",
                "Condition": {
                    "StringEquals": {
                        "oidc.eks.${var.aws_region}.amazonaws.com/id/${regex("([^\\/]+$)", data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer)[0]}:aud": "sts.amazonaws.com"
                    },
                    "StringLike": {
                        "oidc.eks.${var.aws_region}.amazonaws.com/id/${regex("([^\\/]+$)", data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer)[0]}:sub": "k2view-*"
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


resource "aws_iam_role_policy_attachment" "iam_deployer_role_policy_attachment" {
    role       = aws_iam_role.iam_deployer_role.name
    policy_arn = aws_iam_policy.iam_deployer_policy.arn
}
