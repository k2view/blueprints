# Policy
data "aws_iam_policy_document" "kubernetes_cluster_autoscaler" {
  statement {
    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeScalingActivities",
      "autoscaling:DescribeTags",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "ec2:DescribeImages",
      "ec2:DescribeLaunchTemplateVersions",
      "ec2:DescribeInstanceTypes",
      "ec2:GetInstanceTypesFromInstanceRequirements",
      "eks:Describe*",
      "eks:DescribeNodegroup",
      "eks:List*"
    ]
    resources = [
      "*",
    ]
    effect = "Allow"
  }

}


resource "aws_iam_policy" "kubernetes_cluster_autoscaler" {
  name        = "${var.cluster_name}-cluster-autoscaler-policy"
  path        = "/"
  description = "Policy for cluster autoscaler service"

  policy = data.aws_iam_policy_document.kubernetes_cluster_autoscaler.json
}



resource "aws_iam_role_policy_attachment" "kubernetes_cluster_autoscaler" {
  role       = var.role
  policy_arn = aws_iam_policy.kubernetes_cluster_autoscaler.arn
}

resource "helm_release" "cluster_autoscaler" {
  name       = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  namespace  = "kube-system"

  set {
    name  = "autoDiscovery.clusterName"
    value = "${var.cluster_name}"
  }

  set {
    name  = "awsRegion"
    value = "${var.region}"
  }

}